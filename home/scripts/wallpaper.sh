#!/usr/bin/env bash

# Set the path to your wallpapers folder
WALLPAPERS_FOLDER="$HOME/nixConfig/bgs"

# Check if the wallpapers folder exists
if [ ! -d "$WALLPAPERS_FOLDER" ]; then
    echo "Error: Wallpapers folder does not exist"
    exit 1
fi

# Get a list of image files in the wallpapers folder
wallpapers=("$WALLPAPERS_FOLDER"/*.{jpg,jpeg,png,gif})

# Check if there are any wallpapers
if [ ${#wallpapers[@]} -eq 0 ]; then
    echo "Error: No wallpapers found in the specified folder"
    exit 1
fi

# Choose a random wallpaper
WALLPAPER_PATH="${wallpapers[RANDOM % ${#wallpapers[@]}]}"

echo "Selected wallpaper: $WALLPAPER_PATH"

# Generate color scheme with pywal
wal -i "$WALLPAPER_PATH"

# Set the wallpaper with swww
swww img "$WALLPAPER_PATH"

# Update Firefox colors with pywalfox
pywalfox update

# Optional: Reload Hyprland config to apply any theme changes
hyprctl reload