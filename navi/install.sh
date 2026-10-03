#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"

info()  { echo "[INFO] $1"; }
warn()  { echo "[WARN] $1"; }
error() { echo "[ERROR] $1" >&2; }

echo "Starting navi installation and configuration..."

# 1. Install navi if not present
if ! command -v navi &> /dev/null; then
    info "navi not found. Installing to ~/.local/bin..."
    mkdir -p "$INSTALL_DIR"
    
    # Official installation script mapped to local bin
    curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install | bash -s -- --dir "$INSTALL_DIR"
    
    info "navi installed successfully."
else
    info "navi is already installed."
fi

# 2. Prepare local cheats directory
CHEATS_SOURCE_DIR="$SCRIPT_DIR/cheats"
mkdir -p "$CHEATS_SOURCE_DIR"

# Generate a sample cheat file if the directory is empty
if [ -z "$(ls -A "$CHEATS_SOURCE_DIR")" ]; then
    info "Creating a sample ros2.cheat file..."
    cat << 'EOF' > "$CHEATS_SOURCE_DIR/ros2.cheat"
% ros2, python, cpp

# Create a ROS 2 Python package
ros2 pkg create --build-type ament_python <package_name> --dependencies rclpy

# Create a ROS 2 C++ package
ros2 pkg create --build-type ament_cmake <package_name> --dependencies rclcpp
EOF
fi

# 3. Symlink to navi's native data directory
# navi automatically scans all directories inside ~/.local/share/navi/cheats/
NAVI_DATA_DIR="$HOME/.local/share/navi/cheats"
mkdir -p "$NAVI_DATA_DIR"

info "Creating symlink for custom cheats..."
ln -sfn "$CHEATS_SOURCE_DIR" "$NAVI_DATA_DIR/home_cfg_cheats"

echo "navi configuration finished."
