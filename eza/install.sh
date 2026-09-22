#!/usr/bin/env bash

set -euo pipefail

INSTALL_DIR="$HOME/.local/bin"

info()  { echo "[INFO] $1"; }
error() { echo "[ERROR] $1" >&2; }

echo "Starting eza installation..."

if ! command -v eza &> /dev/null; then
    info "eza not found. Installing to ~/.local/bin..."
    
    ARCH=$(uname -m)
    if [[ "$ARCH" == "x86_64" ]]; then
        EZA_ARCH="x86_64-unknown-linux-gnu"
    elif [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
        EZA_ARCH="aarch64-unknown-linux-gnu"
    else
        error "Architecture $ARCH not supported by this script."
        exit 1
    fi

    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"

    # Get latest version tag
    EZA_VERSION=$(curl -s "https://api.github.com/repos/eza-community/eza/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    
    if [ -z "$EZA_VERSION" ]; then
        error "Could not fetch latest eza version."
        exit 1
    fi

    info "Downloading eza version ${EZA_VERSION}..."
    DOWNLOAD_URL="https://github.com/eza-community/eza/releases/latest/download/eza_${EZA_ARCH}.tar.gz"
    
    if curl -fsSLo eza.tar.gz "$DOWNLOAD_URL"; then
        tar xf eza.tar.gz
        
        mkdir -p "$INSTALL_DIR"
        mv eza "$INSTALL_DIR/"
        chmod +x "$INSTALL_DIR/eza"
        
        info "eza installed successfully."
    else
        error "Failed to download eza."
        exit 1
    fi

    cd - > /dev/null
    rm -rf "$TMP_DIR"
else
    info "eza is already installed."
fi

echo "eza installation finished."
