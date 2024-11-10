#!/usr/bin/env bash

# Use a specific ID for brightness notifications
notify_id="1235"

# Get brightness percentage
brightness=$(brightnessctl g)
max_brightness=$(brightnessctl m)
brightness_percent=$((brightness * 100 / max_brightness))

# Update notification
notify-send "Brightness" "$brightness_percent%" -h int:value:$brightness_percent -h string:synchronous:brightness -h string:x-canonical-private-synchronous:sys-notify -u low -r $notify_id
