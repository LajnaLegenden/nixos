#!/usr/bin/env bash

# Set the path to your wallpapers folder
WALLPAPERS_FOLDER="$HOME/nixConfig/bgs"
# Set the path for the symlink to the current wallpaper
CURRENT_WALLPAPER="$WALLPAPERS_FOLDER/current"

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

# Write the current wallpaper path to the file
echo "$WALLPAPER_PATH" > "$HOME/.cache/current_wallpaper"
echo "Updated current wallpaper file: $HOME/.cache/current_wallpaper"

# Generate color scheme with pywal
wal -i "$WALLPAPER_PATH"

# Set the wallpaper with swww
swww img "$WALLPAPER_PATH"

# Update Firefox colors with pywalfox
pywalfox update

# Generate new Hyprlock configuration
$HOME/.config/hypr/generate_hyprlock_config.sh

# Optional: Reload Hyprland config to apply any theme changes
hyprctl reload

echo "Wallpaper and configurations updated successfully!"