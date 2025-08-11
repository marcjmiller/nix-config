#!/usr/bin/env bash

# Script to toggle touchpad based on monitor connection
# For use with Hyprland on NixOS

# Define the name of the external monitor from variables.nix
MAIN_MONITOR="GIGA-BYTE TECHNOLOGY CO. LTD. M28U 22100B010513"

# Get the touchpad device
TOUCHPAD_DEVICE=$(hyprctl devices -j | yq -r '.mice[] | select(.name | test("touchpad")) | .name')

if [ -z "$TOUCHPAD_DEVICE" ]; then
    TOUCHPAD_DEVICE=$(hyprctl devices -j | yq -r '.mice[] | select(.name | test("touchpad")) | .name')
fi

if [ -z "$TOUCHPAD_DEVICE" ]; then
    notify-send "Touchpad Toggle" "Could not find touchpad device" --icon=dialog-error
    exit 1
fi

# Check if external monitor is connected
MONITORS=$(hyprctl monitors -j)
MAIN_MONITOR_CONNECTED=$(echo "$MONITORS" | yq -r ".[] | select(.description == \"$MAIN_MONITOR\") | .description")

if [ -n "$MAIN_MONITOR_CONNECTED" ]; then
    # External monitor connected, disable touchpad
    hyprctl keyword "device[${TOUCHPAD_DEVICE}]:enabled" "false"
    notify-send "Touchpad Disabled" "External monitor detected" --icon=input-touchpad
else
    # No external monitor, enable touchpad
    hyprctl keyword "device[${TOUCHPAD_DEVICE}]:enabled" "true"
    notify-send "Touchpad Enabled" "No external monitor detected" --icon=input-touchpad
fi
                                              