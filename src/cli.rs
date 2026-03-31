use clap::{Parser, Subcommand};

#[derive(Parser, Debug)]
#[command(name = "alacritty-theme")]
#[command(about = "Switch Alacritty theme by rewriting alacritty.toml")]
pub struct Cli {
    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand, Debug)]
pub enum Commands {
    /// Set Alacritty theme name
    Set { theme_name: String },
    /// List available themes
    #[command(alias = "ls")]
    List,
}
