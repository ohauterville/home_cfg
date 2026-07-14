#!/usr/bin/env bash
#
# install_nvim.sh - Install Neovim (latest stable) via AppImage
#
# No root privileges required. Installs into ~/.local/bin.
#
# Usage:
#   ./install_nvim.sh                # install into ~/.local/bin
#   ./install_nvim.sh --to /opt/nvim # install into a custom directory (may require sudo)

set -euo pipefail

INSTALL_DIR="${HOME}/.local/bin"
NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"

info()  { echo "[INFO] $1"; }
warn()  { echo "[WARN] $1"; }
error() { echo "[ERROR] $1" >&2; }

# ----------------------------
# Parse arguments
# ----------------------------
while [[ $# -gt 0 ]]; do
    case "$1" in
        --to)
            INSTALL_DIR="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [--to /install/path]"
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            exit 1
            ;;
    esac
done

# ----------------------------
# Check dependencies
# ----------------------------
if ! command -v curl &> /dev/null; then
    error "curl is not installed. Install it with: sudo apt install curl"
    exit 1
fi

# ----------------------------
# Check for existing install
# ----------------------------
if command -v nvim &> /dev/null; then
    CURRENT_VERSION=$(nvim --version | head -n1)
    warn "neovim is already installed: ${CURRENT_VERSION}"
    read -rp "Reinstall/update anyway? [y/N] " REPLY
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
        info "Installation cancelled."
        exit 0
    fi
fi

# ----------------------------
# Download and extract AppImage
# ----------------------------
info "Downloading Neovim AppImage..."
TMP_DIR=$(mktemp -d)
curl -Lo "${TMP_DIR}/nvim.appimage" "$NVIM_URL"
chmod +x "${TMP_DIR}/nvim.appimage"

info "Extracting AppImage..."
(
    cd "$TMP_DIR"
    ./nvim.appimage --appimage-extract > /dev/null
)

# ----------------------------
# Install into target location
# ----------------------------
NVIM_OPT_DIR="${HOME}/.local/opt/nvim"
mkdir -p "$(dirname "$NVIM_OPT_DIR")"
rm -rf "$NVIM_OPT_DIR"
mv "${TMP_DIR}/squashfs-root" "$NVIM_OPT_DIR"

mkdir -p "$INSTALL_DIR"
ln -sf "${NVIM_OPT_DIR}/AppRun" "${INSTALL_DIR}/nvim"

rm -rf "$TMP_DIR"

# ----------------------------
# Add to PATH if needed
# ----------------------------
add_to_path_if_missing() {
    local rc_file="$1"
    if [[ -f "$rc_file" ]] && ! grep -qF "$INSTALL_DIR" "$rc_file"; then
        info "Adding ${INSTALL_DIR} to PATH in ${rc_file}"
        echo "" >> "$rc_file"
        echo "# Added by install_nvim.sh" >> "$rc_file"
        echo "export PATH=\"\$PATH:${INSTALL_DIR}\"" >> "$rc_file"
    fi
}

add_to_path_if_missing "${HOME}/.bashrc"
add_to_path_if_missing "${HOME}/.zshrc"

# ----------------------------
# Verify
# ----------------------------
if [[ -x "${INSTALL_DIR}/nvim" ]]; then
    INSTALLED_VERSION=$("${INSTALL_DIR}/nvim" --version | head -n1)
    info "Neovim installed successfully: ${INSTALLED_VERSION}"
    info "Binary location: ${INSTALL_DIR}/nvim"
    warn "Reload your shell or run: source ~/.bashrc"
else
    error "Installation failed: binary not found at ${INSTALL_DIR}/nvim"
    exit 1
fi

info "Done. Run 'nvim' to start."