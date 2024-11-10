#!/usr/bin/env bash

# Use a specific ID for volume notifications
notify_id="1234"

# Get volume percentage
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1)
# Check if muted
is_muted=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -o yes)

# Update notification
if [ "$is_muted" = "yes" ]; then
  notify-send "Volume" "Muted" -h int:value:$volume -h string:synchronous:volume -h string:x-canonical-private-synchronous:sys-notify -u low -r $notify_id
else
  notify-send "Volume" "$volume%" -h int:value:$volume -h string:synchronous:volume -h string:x-canonical-private-synchronous:sys-notify -u low -r $notify_id
fi
