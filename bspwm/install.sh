#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define dotfiles paths
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BSPWM_SRC="${DOTFILES_DIR}/bspwm/bspwmrc"
SXHKD_SRC="${DOTFILES_DIR}/sxhkd/sxhkdrc"
POLYBAR_CONFIG_SRC="${DOTFILES_DIR}/polybar/config.ini"
POLYBAR_LAUNCH_SRC="${DOTFILES_DIR}/polybar/launch.sh"
POLYBAR_SCRIPT_SRC="${DOTFILES_DIR}/polybar/scripts"

# Define target paths
BSPWM_DEST="${HOME}/.config/bspwm"
SXHKD_DEST="${HOME}/.config/sxhkd"
POLYBAR_DEST="${HOME}/.config/polybar"

echo "Requesting sudo privileges to install system packages..."
sudo apt update
sudo apt install -y bspwm sxhkd rofi terminator feh polybar \
    brightnessctl pavucontrol blueman network-manager-gnome

echo "Creating configuration directories..."
mkdir -p "${BSPWM_DEST}"
mkdir -p "${SXHKD_DEST}"
mkdir -p "${POLYBAR_DEST}"

echo "Creating symlinks..."
ln -sf "${BSPWM_SRC}" "${BSPWM_DEST}/bspwmrc"
ln -sf "${SXHKD_SRC}" "${SXHKD_DEST}/sxhkdrc"
ln -sf "${POLYBAR_CONFIG_SRC}" "${POLYBAR_DEST}/config.ini"
ln -sf "${POLYBAR_LAUNCH_SRC}" "${POLYBAR_DEST}/launch.sh"
ln -sfn "${POLYBAR_SCRIPT_SRC}" "${POLYBAR_DEST}/scripts"

# Ensure scripts are executable
chmod +x "${BSPWM_SRC}"
chmod +x "${POLYBAR_LAUNCH_SRC}"

echo "Installation complete."
