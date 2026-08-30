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

# ----------------------------
# 0. Install Dependencies
# ----------------------------
info "Checking Neovim system dependencies..."
if ! command -v gcc &> /dev/null || ! command -v npm &> /dev/null || ! command -v rg &> /dev/null; then
    info "Installing missing dependencies via apt (will ask for sudo)..."
    sudo apt-update -y || true
    sudo apt install -y build-essential gcc g++ npm ripgrep fd-find xclip
    
    info "Installing tree-sitter-cli globally..."
    sudo npm install -g tree-sitter-cli@0.22.5 #compatible ubuntu 22
else
    info "Dependencies are already installed."
fi

# ----------------------------
# 0. Install devpod for the plugin remote.nvim
# ----------------------------
if ! command -v devpod &> /dev/null; then
    info "Installing devpod for remote-nvim..."
    
    # Détection de l'architecture pour DevPod (amd64 ou arm64)
    ARCH=$(uname -m)
    if [[ "$ARCH" == "x86_64" ]]; then
        DEVPOD_ARCH="amd64"
    elif [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
        DEVPOD_ARCH="arm64"
    else
        warn "Architecture $ARCH non supportée par DevPod. Ignoré."
        DEVPOD_ARCH=""
    fi

    if [[ -n "$DEVPOD_ARCH" ]]; then
        mkdir -p "$INSTALL_DIR"
        
        # Téléchargement direct et sécurisé dans le dossier de destination
        curl -fsSLo "$INSTALL_DIR/devpod" "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-${DEVPOD_ARCH}"
        chmod +x "$INSTALL_DIR/devpod"
        
        info "Devpod installed successfully."
    fi
else 
    info "Devpod is already installed."
fi

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
    
    # LA CORRECTION EST ICI : Le nom officiel du fichier est maintenant nvim-linux-x86_64
    curl -sSLo "${TMP_DIR}/nvim-linux-x86_64.tar.gz" "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"

    # Clean old opt dir if it exists and extract
    rm -rf "$NVIM_OPT_DIR"
    mkdir -p "$(dirname "$NVIM_OPT_DIR")"
    tar -C "${HOME}/.local/opt" -xzf "${TMP_DIR}/nvim-linux-x86_64.tar.gz"
    mv "${HOME}/.local/opt/nvim-linux-x86_64" "$NVIM_OPT_DIR"

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
# 2. Symlink Configuration (Inside real directory to avoid vim.pack bugs)
# ----------------------------
if [[ ! -d "$REPO_CONFIG_DIR" ]]; then
    error "Configuration directory not found at $REPO_CONFIG_DIR."
    exit 1
fi

# Backup if a real directory already exists (and is not empty/just symlinks)
if [[ -e "$NVIM_CONFIG_DIR" && ! -L "$NVIM_CONFIG_DIR" ]]; then
    BACKUP_DIR="${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
    warn "Existing raw nvim config found at ${NVIM_CONFIG_DIR}"
    warn "Backing it up to ${BACKUP_DIR}"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
elif [[ -L "$NVIM_CONFIG_DIR" ]]; then
    info "Removing old directory symlink at ${NVIM_CONFIG_DIR}"
    rm "$NVIM_CONFIG_DIR"
fi

# Create a REAL directory
mkdir -p "$NVIM_CONFIG_DIR"

info "Creating symlinks inside ${NVIM_CONFIG_DIR}"
# Link the core Kickstart files
ln -sf "${REPO_CONFIG_DIR}/init.lua" "${NVIM_CONFIG_DIR}/init.lua"
ln -sfn "${REPO_CONFIG_DIR}/lua" "${NVIM_CONFIG_DIR}/lua"

# ----------------------------
# 3. Headless plugin install/update
# ----------------------------
info "Running headless plugin update..."
# Utilisation de la nouvelle commande vim.pack pour installer les plugins manquants
nvim --headless "+lua vim.pack.update()" +qa 2>/dev/null || true

info "Neovim installation and configuration finished!"
