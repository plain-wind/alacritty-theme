#!/usr/bin/env bash
set -euo pipefail

BIN_NAME="alacritty-theme"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
TARGET="$INSTALL_DIR/$BIN_NAME"

if [[ -f "$TARGET" ]]; then
  rm -f "$TARGET"
  echo "Removed: $TARGET"
else
  echo "Nothing to remove: $TARGET"
fi

echo "Done."