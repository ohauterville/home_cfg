#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting tldr installation..."

# 1. Install tldr (tealdeer implementation) if not present
if ! command -v tldr &> /dev/null; then
    echo "tldr not found. Installing tealdeer (Rust implementation) to ~/.local/bin..."
    
    mkdir -p "$HOME/.local/bin"
    
    # CORRECTED URL: Added '-musl' to the end of the filename
    curl -sSLo "$HOME/.local/bin/tldr" "https://github.com/dbrgn/tealdeer/releases/latest/download/tealdeer-linux-x86_64-musl"
    
    # Make it executable
    chmod +x "$HOME/.local/bin/tldr"
    
    echo "tldr installed successfully."
else
    echo "tldr is already installed."
fi

# 2. Symlink the configuration file
TLDR_CONFIG_DIR="$HOME/.config/tealdeer"
mkdir -p "$TLDR_CONFIG_DIR"

if [ -f "$SCRIPT_DIR/config.toml" ]; then
    echo "Creating symlink for tldr config..."
    ln -sf "$SCRIPT_DIR/config.toml" "$TLDR_CONFIG_DIR/config.toml"
else
    echo "Warning: No config.toml file found in $SCRIPT_DIR. Skipping."
fi

# 3. Update the cache for the first time
echo "Updating tldr cache..."
if [ -x "$HOME/.local/bin/tldr" ]; then
    "$HOME/.local/bin/tldr" --update
elif command -v tldr &> /dev/null; then
    tldr --update
fi

echo "tldr installation finished."