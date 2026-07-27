#!/usr/bin/env bash

set -euo pipefail

echo "Starting fonts installation..."

sudo apt install -y unzip wget

# Use fc-list to check if JetBrainsMono is already known by the system
if fc-list | grep -qi "JetBrainsMono"; then
    echo "JetBrains Mono Nerd Font is already installed. Skipping."
else
    echo "JetBrains Mono not found. Downloading and installing..."
    
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    
    TMP_DIR=$(mktemp -d)
    
    echo "Downloading JetBrainsMono.zip..."
    curl -sSLo "$TMP_DIR/JetBrainsMono.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    
    echo "Extracting fonts..."
    # -o overwrites without prompting, -j junks paths (extracts flat), -d specifies destination
    unzip -o -q "$TMP_DIR/JetBrainsMono.zip" -d "$FONT_DIR/"
    
    echo "Updating font cache..."
    fc-cache -fv &> /dev/null
    
    rm -rf "$TMP_DIR"
    echo "Fonts installed successfully."
fi

echo "Fonts configuration finished."