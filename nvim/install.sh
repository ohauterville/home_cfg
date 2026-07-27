#!/usr/bin/env bash
#
# install.sh - Install Neovim and link personal configuration
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# On suppose que tes fichiers (init.lua, etc.) sont dans le dossier 'config' à côté de ce script
REPO_CONFIG_DIR="${SCRIPT_DIR}/config"
NVIM_CONFIG_DIR="${HOME}/.config/nvim"
INSTALL_DIR="${HOME}/.local/bin"

info()  { echo "[INFO] $1"; }
warn()  { echo "[WARN] $1"; }
error() { echo "[ERROR] $1" >&2; }

echo "Starting Neovim installation and configuration..."

# ----------------------------
# 1. Install Neovim (if not present)
# ----------------------------
if ! command -v nvim &> /dev/null; then
    info "Neovim not found. Installing latest stable version (tar.gz) to ~/.local/bin..."

    mkdir -p "$INSTALL_DIR"
    NVIM_OPT_DIR="${HOME}/.local/opt/nvim"

    # Download and extract the official tar.gz release
    TMP_DIR=$(mktemp -d)
    curl -sSLo "${TMP_DIR}/nvim-linux64.tar.gz" "https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"

    # Clean old opt dir if it exists and extract
    rm -rf "$NVIM_OPT_DIR"
    mkdir -p "$(dirname "$NVIM_OPT_DIR")"
    tar -C "${HOME}/.local/opt" -xzf "${TMP_DIR}/nvim-linux64.tar.gz"
    mv "${HOME}/.local/opt/nvim-linux64" "$NVIM_OPT_DIR"

    # Symlink the binary
    ln -sf "${NVIM_OPT_DIR}/bin/nvim" "${INSTALL_DIR}/nvim"

    rm -rf "$TMP_DIR"
    info "Neovim binary installed successfully."
else
    info "Neovim is already installed: $(nvim --version | head -n1 | grep -oP '\d+\.\d+\.\d+')"
fi

# Make sure the local bin is in PATH for the rest of this script
export PATH="$INSTALL_DIR:$PATH"

# ----------------------------
# 2. Symlink Configuration
# ----------------------------
if [[ ! -d "$REPO_CONFIG_DIR" ]]; then
    error "Configuration directory not found at $REPO_CONFIG_DIR."
    error "Make sure your init.lua is inside a 'config' directory next to this script!"
    exit 1
fi

if [[ -e "$NVIM_CONFIG_DIR" && ! -L "$NVIM_CONFIG_DIR" ]]; then
    BACKUP_DIR="${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
    warn "Existing raw nvim config found at ${NVIM_CONFIG_DIR}"
    warn "Backing it up to ${BACKUP_DIR}"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
elif [[ -L "$NVIM_CONFIG_DIR" ]]; then
    info "Removing old symlink at ${NVIM_CONFIG_DIR}"
    rm "$NVIM_CONFIG_DIR"
fi

info "Creating symlink: ${NVIM_CONFIG_DIR} -> ${REPO_CONFIG_DIR}"
ln -sfn "$REPO_CONFIG_DIR" "$NVIM_CONFIG_DIR"

# ----------------------------
# 3. Headless plugin install/update
# ----------------------------
info "Running headless plugin update..."
# Utilisation de la nouvelle commande vim.pack pour installer les plugins manquants
nvim --headless "+lua vim.pack.update()" +qa 2>/dev/null || true

info "Neovim installation and configuration finished!"