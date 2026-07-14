#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting tmux configuration..."

# 1. Install tmux if not present
if ! command -v tmux &> /dev/null; then
    echo "tmux not found. Installing via apt (will ask for sudo password)..."
    sudo apt-update -y || true
    sudo apt install -y tmux
else
    echo "tmux is already installed."
fi

# 2. Install TPM (Tmux Plugin Manager) safely
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    echo "Cloning TPM repository..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    echo "TPM is already installed."
fi

# 3. Symlink the configuration file
# Assuming you have a file named 'tmux.conf' in your home_cfg/tmux folder
if [ -f "$SCRIPT_DIR/tmux.conf" ]; then
    echo "Creating symlink for tmux.conf..."
    ln -sf "$SCRIPT_DIR/tmux.conf" "$HOME/.tmux.conf"
else
    echo "Warning: No tmux.conf found in $SCRIPT_DIR. Skipping symlink."
fi

# 4. Reload tmux config safely
# Only attempt to source the file if a tmux server is currently running
if pgrep tmux &> /dev/null; then
    echo "Reloading tmux configuration..."
    tmux source-file "$HOME/.tmux.conf"
else
    echo "Tmux is not currently running. Configuration will be applied on next start."
fi

echo "tmux configuration finished."