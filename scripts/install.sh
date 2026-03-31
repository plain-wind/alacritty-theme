#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_NAME="alacritty-theme"
TARGET_BIN="$PROJECT_ROOT/target/release/$BIN_NAME"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"

echo "Building release binary..."
cargo build --release --manifest-path "$PROJECT_ROOT/Cargo.toml"

mkdir -p "$INSTALL_DIR"
install -m 0755 "$TARGET_BIN" "$INSTALL_DIR/$BIN_NAME"

echo "Installed: $INSTALL_DIR/$BIN_NAME"

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