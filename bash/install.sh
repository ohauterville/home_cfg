#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting bash aliases configuration..."

TARGET_FILE="$HOME/.bash_aliases"
SOURCE_FILE="$SCRIPT_DIR/.bash_aliases"

# Check if the source file exists in the repository
if [ -f "$SOURCE_FILE" ]; then
    echo "Creating symlink for bash aliases..."
    
    # -s creates a symbolic link
    # -f forces the creation, removing any existing file or link at the target destination
    ln -sf "$SOURCE_FILE" "$TARGET_FILE"
    
    echo "Symlink created successfully."
else
    echo "Warning: No .bash_aliases file found in $SCRIPT_DIR. Skipping."
fi

echo "Bash aliases configuration finished."
echo "Note: Run 'source ~/.bashrc' or open a new terminal to apply the aliases."