#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_NAME="alacritty-theme"
TARGET_BIN="$PROJECT_ROOT/target/release/$BIN_NAME"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
BASH_COMPLETION_DIR="${BASH_COMPLETION_DIR:-$HOME/.local/share/bash-completion/completions}"
ZSH_COMPLETION_DIR="${ZSH_COMPLETION_DIR:-$HOME/.zsh/completions}"
ALACRITTY_CONFIG_DIR="${ALACRITTY_CONFIG_DIR:-$HOME/.config/alacritty}"
DEFAULT_TOML_SOURCE="$PROJECT_ROOT/default.toml"
DEFAULT_TOML_TARGET="$ALACRITTY_CONFIG_DIR/default.toml"

echo "Building release binary..."
cargo build --release --manifest-path "$PROJECT_ROOT/Cargo.toml"

mkdir -p "$INSTALL_DIR"
install -m 0755 "$TARGET_BIN" "$INSTALL_DIR/$BIN_NAME"

echo "Installed: $INSTALL_DIR/$BIN_NAME"

mkdir -p "$ALACRITTY_CONFIG_DIR"
if [[ ! -f "$DEFAULT_TOML_TARGET" ]]; then
  install -m 0644 "$DEFAULT_TOML_SOURCE" "$DEFAULT_TOML_TARGET"
  echo "Installed default config: $DEFAULT_TOML_TARGET"
else
  echo "default.toml already exists, keeping: $DEFAULT_TOML_TARGET"
fi

mkdir -p "$BASH_COMPLETION_DIR"
install -m 0644 \
  "$PROJECT_ROOT/scripts/completions/alacritty-theme.bash" \
  "$BASH_COMPLETION_DIR/$BIN_NAME"
echo "Installed bash completion: $BASH_COMPLETION_DIR/$BIN_NAME"

mkdir -p "$ZSH_COMPLETION_DIR"
install -m 0644 \
  "$PROJECT_ROOT/scripts/completions/_alacritty-theme" \
  "$ZSH_COMPLETION_DIR/_alacritty-theme"
echo "Installed zsh completion: $ZSH_COMPLETION_DIR/_alacritty-theme"

case ":${PATH}:" in
  *":$INSTALL_DIR:"*)
    echo "PATH already contains $INSTALL_DIR"
    ;;
  *)
    echo "Add this line to your shell config to use the command globally:"
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    ;;
esac

echo "Done. Try: $BIN_NAME --help"
echo
echo "Enable completion (one-time):"
echo "  Bash: source \"$BASH_COMPLETION_DIR/$BIN_NAME\""
echo "  Zsh:  add 'fpath=(\"$ZSH_COMPLETION_DIR\" \$fpath)' to ~/.zshrc, then run 'autoload -Uz compinit && compinit'"