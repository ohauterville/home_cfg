#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting Vim configuration..."

TARGET_VIMRC="$HOME/.vimrc"
SOURCE_VIMRC="$SCRIPT_DIR/.vimrc"

if [ -f "$SOURCE_VIMRC" ]; then
    echo "Creating symlink for .vimrc..."
    ln -sf "$SOURCE_VIMRC" "$TARGET_VIMRC"
else
    echo "Warning: No .vimrc file found in $SCRIPT_DIR. Skipping."
fi

echo "Vim configuration finished."
