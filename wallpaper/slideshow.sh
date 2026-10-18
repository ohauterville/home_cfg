#!/usr/bin/env bash

INTERVAL=600
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Ensure directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Directory $WALLPAPER_DIR does not exist. Exiting."
    exit 1
fi

# Detect the desktop environment (lowercase for easier matching)
detect_desktop() {
    local de="${XDG_CURRENT_DESKTOP:-$DESKTOP_SESSION}"
    de="${de,,}"
    case "$de" in
        *gnome*|*unity*|*ubuntu*) echo "gnome" ;;
        *bspwm*)                  echo "bspwm" ;;
        *)
            # Fallback: check running processes
            if pgrep -x bspwm >/dev/null; then
                echo "bspwm"
            elif pgrep -x gnome-shell >/dev/null; then
                echo "gnome"
            else
                echo "unknown"
            fi
            ;;
    esac
}

DESKTOP=$(detect_desktop)

# Session bus is needed for gsettings when run from a systemd service
if [ "$DESKTOP" = "gnome" ]; then
    export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/$(id -u)/bus}"
fi

# feh needs access to the X display when run from a systemd service
if [ "$DESKTOP" = "bspwm" ]; then
    export DISPLAY="${DISPLAY:-:0}"
    export XAUTHORITY="${XAUTHORITY:-$HOME/.Xauthority}"
fi

# Set the wallpaper depending on the desktop
set_wallpaper() {
    local pic="$1"
    case "$DESKTOP" in
        gnome)
            # Set wallpaper for both Light and Dark themes in GNOME
            gsettings set org.gnome.desktop.background picture-uri "file://$pic"
            gsettings set org.gnome.desktop.background picture-uri-dark "file://$pic"
            ;;
        bspwm)
            # --bg-fill scales and crops to fill the screen (multi-monitor safe)
            feh --bg-fill "$pic"
            ;;
        *)
            echo "Unsupported desktop environment: $DESKTOP"
            return 1
            ;;
    esac
}

# Check that the required tool is installed
case "$DESKTOP" in
    gnome)
        command -v gsettings >/dev/null || { echo "gsettings not found. Exiting."; exit 1; } ;;
    bspwm)
        command -v feh >/dev/null || { echo "feh not found (install it: sudo apt install feh). Exiting."; exit 1; } ;;
    *)
        echo "Could not detect a supported desktop. Exiting."; exit 1 ;;
esac

echo "Starting wallpaper slideshow (desktop: $DESKTOP)..."

while true; do
    # Find a random image (jpg, jpeg or png, case-insensitive)
    PIC=$(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | shuf -n 1)

    if [ -n "$PIC" ]; then
        echo "Setting wallpaper to: $PIC"
        set_wallpaper "$PIC"
    fi

    sleep "$INTERVAL"
done
