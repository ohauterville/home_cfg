#!/usr/bin/env bash

set -euo pipefail

echo "Starting fzf installation..."

# Check if fzf is already installed
if ! command -v fzf &> /dev/null; then
    echo "fzf not found. Installing via official git repository..."
    
    # Define installation directory
    FZF_DIR="$HOME/.fzf"
    
    # Remove directory if it exists but is corrupted/empty
    if [ -d "$FZF_DIR" ]; then
        rm -rf "$FZF_DIR"
    fi

    # Clone the repository (depth 1 for faster cloning)
    git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_DIR"

    # Run the official installer
    # --key-bindings: enables Ctrl-R, Ctrl-T, Alt-C
    # --completion: enables fuzzy completion (e.g., kill <tab>)
    # --no-update-rc: CRUCIAL - prevents the script from modifying your .bashrc
    "$FZF_DIR/install" --key-bindings --completion --no-update-rc
    
    echo "fzf installed successfully."
else
    echo "fzf is already installed."
    
    # Optional: Update fzf if already installed
    # Uncomment the following lines if you want the script to also update fzf automatically
    echo "Updating fzf..."
    cd "$HOME/.fzf" && git pull && ./install --key-bindings --completion --no-update-rc
fi

echo "fzf configuration finished."