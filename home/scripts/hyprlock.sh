#!/usr/bin/env bash

CONFIG_FILE="$HOME/.config/hypr/hyprlock.conf"
WALLPAPER_FILE="$HOME/nixConfig/bgs/current"
COLORS_FILE="$HOME/.cache/wal/colors.json"

# Ensure the wallpaper file exists
if [ ! -f "$WALLPAPER_FILE" ]; then
    echo "Error: Current wallpaper file not found"
    exit 1
fi

# Read the current wallpaper path
WALLPAPER=$(cat "$WALLPAPER_FILE")

# Function to convert hex color to rgb
hex_to_rgb() {
    hex=$1
    r=$(printf %d 0x${hex:1:2})
    g=$(printf "%d" 0x${hex:3:2})
    b=$(printf "%d" 0x${hex:5:2})
    echo "rgb($r, $g, $b)"
}

# Read colors from pywal
if [ -f "$COLORS_FILE" ]; then
    BG_COLOR=$(jq -r '.special.background' "$COLORS_FILE")
    FG_COLOR=$(jq -r '.special.foreground' "$COLORS_FILE")
    ACCENT_COLOR=$(jq -r '.colors.color1' "$COLORS_FILE")

    # Convert colors to rgb format
    BG_COLOR=$(hex_to_rgb $BG_COLOR)
    FG_COLOR=$(hex_to_rgb $FG_COLOR)
    ACCENT_COLOR=$(hex_to_rgb $ACCENT_COLOR)
else
    BG_COLOR="rgb(25, 20, 20)"
    FG_COLOR="rgb(200, 200, 200)"
    ACCENT_COLOR="rgb(100, 100, 100)"
fi

cat > "$CONFIG_FILE" << EOF
general {
    enable_fingerprint = true
    fingerprint_ready_message = "<i>Use TouchID to unlock</i>"
    fingerprint_present_message = "<i>Verifying...</i>"
}

general {
    immediate_render = true
}

background {
    monitor =
    path = $HOME/nixConfig/current   # only png supported for now
    color = $BG_COLOR

    # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
    blur_passes = 0 # 0 disables blurring
    blur_size = 2
    noise = 0
    contrast = 0
    brightness = 0
    vibrancy = 0
    vibrancy_darkness = 0.0
}

input-field {
    monitor =
    size = 300, 30
    outline_thickness = 0
    dots_size = 0.25 # Scale of input-field height, 0.2 - 0.8
    dots_spacing = 0.55 # Scale of dots' absolute size, 0.0 - 1.0
    dots_center = true
    dots_rounding = -1
    outer_color = rgba(242, 243, 244, 0)
    inner_color = rgba(242, 243, 244, 0)
    font_color = rgba(242, 243, 244, 0.75)
    fade_on_empty = false
    placeholder_text = # Text rendered in the input box when it's empty.
    hide_input = false
    check_color = rgba(204, 136, 34, 0)
    fail_color = rgba(204, 34, 34, 0) # if authentication failed, changes outer_color and fail message color
    fail_text = $FAIL <b>($ATTEMPTS)</b> # can be set to empty
    fail_transition = 300 # transition time in ms between normal outer_color and fail_color
    capslock_color = -1
    numlock_color = -1
    bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
    invert_numlock = false # change color if numlock is off
    swap_font_color = false # see below
    position = 0, -468
    halign = center
    valign = center
}

label {
  monitor =
  text = cmd[update:1000] echo "$(date +"%A, %B %d")"
  color = rgba(242, 243, 244, 0.75)
  font_size = 20
  font_family = SF Pro Display Bold
  position = 0, 405
  halign = center
  valign = center
}

label {
  monitor = 
  text = cmd[update:1000] echo "$(date +"%k:%M")"
  color = rgba(242, 243, 244, 0.75)
  font_size = 93
  font_family = SF Pro Display Bold
  position = 0, 310
  halign = center
  valign = center
}


label {
    monitor =
    text = Linus Jansson
    color = rgba(242, 243, 244, 0.75)
    font_size = 12
    font_family = SF Pro Display Bold
    position = 0, -407
    halign = center
    valign = center
}

label {
    monitor =
    text = Touch ID or Enter Password
    color = rgba(242, 243, 244, 0.75)
    font_size = 10
    font_family = SF Pro Display
    position = 0, -438
    halign = center
    valign = center
}

EOF

echo "Hyprlock configuration updated at $CONFIG_FILE"
