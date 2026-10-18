#!/usr/bin/env bash
# Simple power menu using rofi

choice=$(printf "󰐥 Shutdown\n󰜉 Reboot\n󰤄 Suspend\n󰍃 Logout" | rofi -dmenu -i -p "Power")

case "$choice" in
    *Shutdown) systemctl poweroff ;;
    *Reboot)   systemctl reboot ;;
    *Suspend)  systemctl suspend ;;
    *Logout)   bspc quit ;;
esac
