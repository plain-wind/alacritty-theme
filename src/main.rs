fn main() {
    if let Err(err) = alacritty_theme::run() {
        if alacritty_theme::is_broken_pipe(&err) {
            std::process::exit(0);
        }
        eprintln!("Error: {err:#}");
        std::process::exit(1);
    }
}
