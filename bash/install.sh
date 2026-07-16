#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting bash configuration..."

# 1. Symlink for bash_aliases
TARGET_ALIASES="$HOME/.bash_aliases"
SOURCE_ALIASES="$SCRIPT_DIR/bash_aliases"

if [ -f "$SOURCE_ALIASES" ]; then
    echo "Creating symlink for bash aliases..."
    ln -sf "$SOURCE_ALIASES" "$TARGET_ALIASES"
else
    echo "Warning: No bash_aliases file found in $SCRIPT_DIR. Skipping."
fi

# 2. Symlink for .bashrc
TARGET_BASHRC="$HOME/.bashrc"
SOURCE_BASHRC="$SCRIPT_DIR/.bashrc"

if [ -f "$SOURCE_BASHRC" ]; then
    echo "Creating symlink for .bashrc..."
    ln -sf "$SOURCE_BASHRC" "$TARGET_BASHRC"
else
    echo "Warning: No .bashrc file found in $SCRIPT_DIR. Skipping."
fi

echo "Bash configuration finished."
echo "Note: Run 'source ~/.bashrc' or open a new terminal to apply the changes."