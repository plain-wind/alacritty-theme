use std::env;
use std::fs;
use std::io::Write;
use std::path::{Path, PathBuf};

use anyhow::{Context, Result, bail};

const THEME_DIR_REL: &str = ".config/alacritty/themes/themes";
const ALA_TOML_REL: &str = ".config/alacritty/alacritty.toml";

pub fn list_themes() -> Result<()> {
    let home_dir = home_dir()?;
    let theme_dir = home_dir.join(THEME_DIR_REL);

    if !theme_dir.is_dir() {
        bail!("Theme directory does not exist: {}", theme_dir.display());
    }

    let mut themes = Vec::new();

    for entry in fs::read_dir(&theme_dir)
        .with_context(|| format!("Failed to read {}", theme_dir.display()))?
    {
        let entry =
            entry.with_context(|| format!("Failed to read an entry in {}", theme_dir.display()))?;
        let path = entry.path();

        if !path.is_file() {
            continue;
        }

        if path.extension().and_then(|e| e.to_str()) != Some("toml") {
            continue;
        }

        if let Some(name) = path.file_stem().and_then(|s| s.to_str()) {
            themes.push(name.to_string());
        }
    }

    themes.sort();

    let stdout = std::io::stdout();
    let mut out = std::io::BufWriter::new(stdout.lock());

    for theme in themes {
        writeln!(out, "{theme}").context("Failed to write theme list output")?;
    }

    Ok(())
}

pub fn set_theme(theme_name: &str) -> Result<()> {
    let home_dir = home_dir()?;
    let theme_path = home_dir
        .join(THEME_DIR_REL)
        .join(format!("{theme_name}.toml"));

    if !theme_path.is_file() {
        bail!("Theme does not exist: {}", theme_path.display());
    }

    let alacritty_toml = home_dir.join(ALA_TOML_REL);
    let content = build_import_content(theme_name);

    fs::write(&alacritty_toml, content)
        .with_context(|| format!("Failed to write {}", alacritty_toml.display()))?;

    println!("Switched Alacritty theme to '{theme_name}'.");
    Ok(())
}

fn build_import_content(theme_name: &str) -> String {
    format!(
        "import = [\n    \"~/.config/alacritty/themes/themes/{theme_name}.toml\",\n    \"~/.config/alacritty/default.toml\"\n]\n"
    )
}

fn home_dir() -> Result<PathBuf> {
    let home = env::var("HOME").context("HOME environment variable is not set")?;
    let path = Path::new(&home);

    if path.as_os_str().is_empty() {
        bail!("HOME environment variable is empty");
    }

    Ok(path.to_path_buf())
}

#[cfg(test)]
mod tests {
    use super::build_import_content;

    #[test]
    fn import_content_matches_expected_template() {
        let out = build_import_content("tokyo-night");
        let expected = "import = [\n    \"~/.config/alacritty/themes/themes/tokyo-night.toml\",\n    \"~/.config/alacritty/default.toml\"\n]\n";
        assert_eq!(out, expected);
    }
}
