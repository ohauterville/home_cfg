#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define paths
# Get the absolute path of the dotfiles root directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NB_MODULE_DIR="${DOTFILES_DIR}/nb"
NB_NOTES_DIR="${NB_MODULE_DIR}/notes"
LOCAL_BIN="${HOME}/.local/bin"
NB_BIN="${LOCAL_BIN}/nb"
NB_RC="${HOME}/.nbrc"

echo "Installing nb..."

# Create local bin directory if it does not exist
mkdir -p "${LOCAL_BIN}"

# Download and install the nb binary
if [ ! -f "${NB_BIN}" ]; then
    echo "Downloading nb binary..."
    curl -sL https://raw.githubusercontent.com/xwmx/nb/master/nb -o "${NB_BIN}"
    chmod +x "${NB_BIN}"
    echo "nb installed to ${NB_BIN}."
else
    echo "nb is already installed in ${LOCAL_BIN}."
    
    # Optional: Update nb to the latest version
    # echo "Updating nb..."
    # "${NB_BIN}" update
fi

# Set up the notes storage directory within the dotfiles repository
echo "Setting up notes directory..."
mkdir -p "${NB_NOTES_DIR}"

# Create a symlink for ~/.nb pointing to the dotfiles notes directory
if [ -L "${HOME}/.nb" ] || [ -d "${HOME}/.nb" ]; then
    # Check if it already points to the right directory
    if [ "$(readlink "${HOME}/.nb")" != "${NB_NOTES_DIR}" ]; then
        echo "Backing up existing ~/.nb to ~/.nb.bak..."
        mv "${HOME}/.nb" "${HOME}/.nb.bak"
        ln -sf "${NB_NOTES_DIR}" "${HOME}/.nb"
    fi
else
    ln -sf "${NB_NOTES_DIR}" "${HOME}/.nb"
fi

# Configure nb to integrate gracefully with the dotfiles Git repository
echo "Configuring ~/.nbrc..."
cat << EOF > "${NB_RC}"
# nb configuration file
# Managed by home_cfg install script

# Disable nb's internal auto-sync to prevent it from spamming the dotfiles Git history
NB_AUTO_SYNC="false"

# Explicitly tell nb to use the current terminal colors and tools
NB_COLOR="true"
NB_MARKDOWN_TOOL="bat"
EOF

echo "nb installation and configuration complete."
