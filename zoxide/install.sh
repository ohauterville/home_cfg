#!/usr/bin/env bash

set -euo pipefail

echo "Starting zoxide installation..."

# 1. Install zoxide if not present
if ! command -v zoxide &> /dev/null; then
    echo "zoxide not found. Installing to ~/.local/bin..."
    
    # Ensure the local bin directory exists
    mkdir -p "$HOME/.local/bin"
    
    # Download and run the official installer
    curl -sSf https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    
    echo "zoxide installed successfully."
else
    echo "zoxide is already installed."
    
    # Optional: Update zoxide
    # curl -sSf https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

echo "zoxide installation finished."