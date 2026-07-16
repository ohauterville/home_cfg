#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting Starship installation..."

# 1. Install Starship if not present
if ! command -v starship &> /dev/null; then
    echo "Starship not found. Installing to ~/.local/bin..."
    
    # Ensure the local bin directory exists
    mkdir -p "$HOME/.local/bin"
    
    # Download and run the official installer
    # -y : skip confirmation prompt
    # -b : specify the installation directory to avoid needing sudo
    curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
    
    echo "Starship installed successfully."
else
    echo "Starship is already installed."
fi

# 2. Symlink the configuration file
STARSHIP_CONFIG_DIR="$HOME/.config"
mkdir -p "$STARSHIP_CONFIG_DIR"

if [ -f "$SCRIPT_DIR/starship.toml" ]; then
    echo "Creating symlink for starship.toml..."
    ln -sf "$SCRIPT_DIR/starship.toml" "$STARSHIP_CONFIG_DIR/starship.toml"
else
    echo "Warning: No starship.toml file found in $SCRIPT_DIR. Skipping."
fi

echo "Starship configuration finished."