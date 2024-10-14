#!/usr/bin/env bash

CONFIG_FILE="$HOME/.config/hypr/hyprlock.conf"
WALLPAPER_FILE="$HOME/.cache/current_wallpaper"
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
    r=$(printf "%d" 0x${hex:1:2})
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
    BG_COLOR=$(hex_to_rgb "$BG_COLOR")
    FG_COLOR=$(hex_to_rgb "$FG_COLOR")
    ACCENT_COLOR=$(hex_to_rgb "$ACCENT_COLOR")
else
    BG_COLOR="rgb(25, 20, 20)"
    FG_COLOR="rgb(200, 200, 200)"
    ACCENT_COLOR="rgb(100, 100, 100)"
fi

# Generate Hyprlock configuration
cat > "$CONFIG_FILE" << EOF
background {
    path = "$WALLPAPER"
    color = "$BG_COLOR"
}

input-field {
    size = 200, 50
    outline_thickness = 3
    dots_size = 0.33
    dots_spacing = 0.15
    outer_color = "$ACCENT_COLOR"
    inner_color = "$FG_COLOR"
    font_color = "$BG_COLOR"
    fade_on_empty = true
    placeholder_text = "<i>Password...</i>"
    hide_input = false
    position = 0, -20
    halign = center
    valign = center
}

label {
    text = Welcome back, \$USER
    color = "$FG_COLOR"
    font_size = 25
    font_family = Sans
    position = 0, 80
    halign = center
    valign = center
}
EOF

echo "Hyprlock configuration updated at $CONFIG_FILE"