#!/usr/bin/env bash
# Bluetooth status and toggle for polybar

connected_name() {
    # Works with old and new bluez: check each known device individually
    local mac info
    for mac in $(bluetoothctl devices | awk '{print $2}'); do
        info=$(bluetoothctl info "$mac")
        if grep -q "Connected: yes" <<< "$info"; then
            grep -m1 "Name:" <<< "$info" | sed 's/^[[:space:]]*Name: //'
            return
        fi
    done
}

case "$1" in
    toggle)
        if bluetoothctl show | grep -q "Powered: yes"; then
            bluetoothctl power off
        else
            bluetoothctl power on
        fi
        ;;
    *)
        if bluetoothctl show | grep -q "Powered: yes"; then
            name=$(connected_name)
            if [ -n "$name" ]; then
                echo "󰂱 $name"
            else
                echo "󰂯 on"
            fi
        else
            echo "󰂲 off"
        fi
        ;;
esac
