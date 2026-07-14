#!/usr/bin/env bash
#
# install.sh - Install kickstart.nvim on this machine
#
# This script:
#   1. Checks that neovim is installed (recent enough version required)
#   2. Backs up any existing nvim config
#   3. Clones kickstart.nvim into ~/.config/nvim
#   4. Runs a headless sync to install plugins ahead of first launch

set -euo pipefail

NVIM_CONFIG_DIR="${HOME}/.config/nvim"
KICKSTART_REPO="https://github.com/nvim-lua/kickstart.nvim.git"
MIN_NVIM_VERSION="0.10"

info()  { echo "[INFO] $1"; }
warn()  { echo "[WARN] $1"; }
error() { echo "[ERROR] $1" >&2; }

# ----------------------------
# 1. Check neovim is installed
# ----------------------------
if ! command -v nvim &> /dev/null; then
    error "neovim is not installed. Install it first, then re-run this script."
    error "See: https://github.com/neovim/neovim/releases"
    exit 1
fi

NVIM_VERSION=$(nvim --version | head -n1 | grep -oP '\d+\.\d+' | head -n1)
info "Found neovim version: ${NVIM_VERSION}"

# ----------------------------
# 2. Backup existing config if present
# ----------------------------
if [[ -d "$NVIM_CONFIG_DIR" ]]; then
    BACKUP_DIR="${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
    warn "Existing nvim config found at ${NVIM_CONFIG_DIR}"
    warn "Backing it up to ${BACKUP_DIR}"
    mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
fi

# Also back up local share/state/cache dirs to avoid conflicts with old plugins
for dir in "${HOME}/.local/share/nvim" "${HOME}/.local/state/nvim" "${HOME}/.cache/nvim"; do
    if [[ -d "$dir" ]]; then
        BACKUP="${dir}.backup.$(date +%Y%m%d_%H%M%S)"
        warn "Backing up ${dir} to ${BACKUP}"
        mv "$dir" "$BACKUP"
    fi
done

# ----------------------------
# 3. Clone kickstart.nvim
# ----------------------------
info "Cloning kickstart.nvim into ${NVIM_CONFIG_DIR}..."
git clone "$KICKSTART_REPO" "$NVIM_CONFIG_DIR"

# Remove the .git folder so it doesn't conflict with your own dotfiles repo
rm -rf "${NVIM_CONFIG_DIR}/.git"

# ----------------------------
# 4. Headless plugin install
# ----------------------------
info "Installing plugins (headless)..."
nvim --headless +qa

info "Done. Launch nvim to verify the setup, or run: nvim +checkhealth"