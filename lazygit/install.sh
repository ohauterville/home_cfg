#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting lazygit installation..."

# 1. Install lazygit if not present
if ! command -v lazygit &> /dev/null; then
    echo "lazygit not found. Fetching the latest version from GitHub..."
    
    # Get the latest version number using the GitHub API
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    
    if [ -z "$LAZYGIT_VERSION" ]; then
        echo "Error: Could not determine the latest lazygit version."
        exit 1
    fi

    echo "Downloading lazygit version ${LAZYGIT_VERSION}..."
    
    # Create a temporary directory for extraction
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"
    
    # Download the Linux x86_64 tarball
    curl -sSLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    
    # Extract only the binary
    tar xf lazygit.tar.gz lazygit
    
    # Move it to the local bin directory
    mkdir -p "$HOME/.local/bin"
    mv lazygit "$HOME/.local/bin/"
    
    # Clean up
    cd - > /dev/null
    rm -rf "$TMP_DIR"
    
    echo "lazygit installed successfully."
else
    echo "lazygit is already installed."
fi

# 2. Symlink the configuration file (optional, if you create one later)
LAZYGIT_CONFIG_DIR="$HOME/.config/lazygit"
mkdir -p "$LAZYGIT_CONFIG_DIR"

if [ -f "$SCRIPT_DIR/config.yml" ]; then
    echo "Creating symlink for lazygit config.yml..."
    ln -sf "$SCRIPT_DIR/config.yml" "$LAZYGIT_CONFIG_DIR/config.yml"
else
    echo "Note: No config.yml file found in $SCRIPT_DIR. Skipping symlink."
fi

echo "lazygit installation finished."