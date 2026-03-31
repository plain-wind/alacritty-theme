#!/usr/bin/env bash
set -euo pipefail

BIN_NAME="alacritty-theme"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
TARGET="$INSTALL_DIR/$BIN_NAME"
BASH_COMPLETION_DIR="${BASH_COMPLETION_DIR:-$HOME/.local/share/bash-completion/completions}"
ZSH_COMPLETION_DIR="${ZSH_COMPLETION_DIR:-$HOME/.zsh/completions}"
TARGET_BASH_COMPLETION="$BASH_COMPLETION_DIR/$BIN_NAME"
TARGET_ZSH_COMPLETION="$ZSH_COMPLETION_DIR/_alacritty-theme"

cleanup_empty_dirs() {
  local dir="$1"

  while [[ -n "$dir" && "$dir" != "/" && "$dir" != "$HOME" ]]; do
    if [[ ! -d "$dir" ]]; then
      break
    fi

    if rmdir "$dir" 2>/dev/null; then
      echo "Removed empty directory: $dir"
      dir="$(dirname "$dir")"
    else
      break
    fi
  done
}

if [[ -f "$TARGET" ]]; then
  rm -f "$TARGET"
  echo "Removed: $TARGET"
  cleanup_empty_dirs "$INSTALL_DIR"
else
  echo "Nothing to remove: $TARGET"
fi

if [[ -f "$TARGET_BASH_COMPLETION" ]]; then
  rm -f "$TARGET_BASH_COMPLETION"
  echo "Removed: $TARGET_BASH_COMPLETION"
  cleanup_empty_dirs "$BASH_COMPLETION_DIR"
else
  echo "Nothing to remove: $TARGET_BASH_COMPLETION"
fi

if [[ -f "$TARGET_ZSH_COMPLETION" ]]; then
  rm -f "$TARGET_ZSH_COMPLETION"
  echo "Removed: $TARGET_ZSH_COMPLETION"
  cleanup_empty_dirs "$ZSH_COMPLETION_DIR"
else
  echo "Nothing to remove: $TARGET_ZSH_COMPLETION"
fi

echo "Done."