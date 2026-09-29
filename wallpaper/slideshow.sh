#!/usr/bin/env bash

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

INTERVAL=600
WALLPAPER_DIR="$HOME/Images/Wallpapers"

# Ensure directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Directory $WALLPAPER_DIR does not exist. Exiting."
    exit 1
fi

echo "Starting GNOME wallpaper slideshow..."

while true; do
    # Find a random image (jpg or png)
    PIC=$(find "$WALLPAPER_DIR" -type f \( -name '*.jpg' -o -name '*.png' \) | shuf -n 1)
    
    if [ -n "$PIC" ]; then
        echo "Setting wallpaper to: $PIC"
        # Set wallpaper for both Light and Dark themes in GNOME
        gsettings set org.gnome.desktop.background picture-uri "file://$PIC"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$PIC"
    fi
    
    sleep $INTERVAL
done
