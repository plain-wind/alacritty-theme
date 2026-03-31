mod cli;
mod theme;

use anyhow::Result;
use clap::Parser;

use crate::cli::{Cli, Commands};

pub fn run() -> Result<()> {
    let cli = Cli::parse();

    match cli.command {
        Commands::Set { theme_name } => theme::set_theme(&theme_name),
        Commands::List => theme::list_themes(),
    }
}

pub fn is_broken_pipe(err: &anyhow::Error) -> bool {
    err.chain().any(|cause| {
        cause
            .downcast_ref::<std::io::Error>()
            .is_some_and(|io_err| io_err.kind() == std::io::ErrorKind::BrokenPipe)
    })
}
