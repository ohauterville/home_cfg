#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v terminator &> /dev/null; then
    echo "Terminator not found. Installing via apt (will ask for sudo password)..."
    sudo apt update -y || true
    sudo apt install -y terminator
else
    echo "Terminator is already installed."
fi

echo "Starting terminator configuration..."

# 1. Symlink for Terminator config
TERMINATOR_CONFIG_DIR="$HOME/.config/terminator"
mkdir -p "$TERMINATOR_CONFIG_DIR"

if [ -f "$SCRIPT_DIR/config" ]; then
    echo "Creating symlink for terminator config..."
    ln -sf "$SCRIPT_DIR/config" "$TERMINATOR_CONFIG_DIR/config"
else
    echo "Warning: No config file found in $SCRIPT_DIR. Skipping."
fi

# 2. Symlink for Desktop entry (Application shortcut)
DESKTOP_ENTRY_DIR="$HOME/.local/share/applications"
mkdir -p "$DESKTOP_ENTRY_DIR"

if [ -f "$SCRIPT_DIR/terminator.desktop" ]; then
    echo "Creating symlink for terminator.desktop..."
    ln -sf "$SCRIPT_DIR/terminator.desktop" "$DESKTOP_ENTRY_DIR/terminator.desktop"
    
    # Refresh the desktop environment to detect the new shortcut
    if command -v update-desktop-database &> /dev/null; then
        echo "Updating desktop database..."
        update-desktop-database "$DESKTOP_ENTRY_DIR" || true
    fi
else
    echo "Warning: No terminator.desktop file found in $SCRIPT_DIR. Skipping."
fi

echo "Terminator configuration finished."