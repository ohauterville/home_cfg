#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting Superfile installation..."

# 1. Install Superfile using the official installer
if ! command -v spf &> /dev/null; then
    echo "[INFO] Superfile not found. Installing via official script..."
    
    # Official one-liner installation script
    bash -c "$(curl -sLo- https://superfile.dev/install.sh)"
    
    echo "[INFO] Superfile installed successfully."
else
    echo "[INFO] Superfile (spf) is already installed."
    
    # Optional: If you want to update it later, superfile has a built-in command
    # spf update
fi

# 2. Symlink Configuration
SPF_CONFIG_DIR="$HOME/.config/superfile"
mkdir -p "$SPF_CONFIG_DIR"

if [ -f "$SCRIPT_DIR/config.toml" ]; then
    echo "[INFO] Creating symlink for superfile config.toml..."
    ln -sfn "$SCRIPT_DIR/config.toml" "$SPF_CONFIG_DIR/config.toml"
else
    echo "[WARN] No config.toml found in $SCRIPT_DIR. Skipping symlink."
fi

echo "Superfile configuration finished."