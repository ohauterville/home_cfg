#!/usr/bin/env bash
#
# This script create a service (systemd) to change wallpaper
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting Wallpaper Service configuration..."

# 1. Ensure the bash script is executable
if [ -f "$SCRIPT_DIR/slideshow.sh" ]; then
    chmod +x "$SCRIPT_DIR/slideshow.sh"
else
    echo "Warning: slideshow.sh not found in $SCRIPT_DIR."
fi

# 2. Create the systemd user directory
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
mkdir -p "$SYSTEMD_USER_DIR"

# 3. Symlink the service file
if [ -f "$SCRIPT_DIR/wallpaper.service" ]; then
    echo "Creating symlink for wallpaper.service..."
    ln -sfn "$SCRIPT_DIR/wallpaper.service" "$SYSTEMD_USER_DIR/wallpaper.service"
else
    echo "Error: wallpaper.service not found in $SCRIPT_DIR. Exiting."
    exit 1
fi

# 4. Reload systemd and enable/start the service
if command -v systemctl &> /dev/null; then
    echo "Reloading systemd user daemon..."
    systemctl --user daemon-reload
    
    echo "Enabling and starting wallpaper.service..."
    # --now enables the service at boot AND starts it immediately
    systemctl --user enable --now wallpaper.service
    
    echo "Wallpaper service installed and running successfully."
else
    echo "Warning: systemctl command not found. Cannot start the service."
fi

echo "Wallpaper configuration finished."
