#!/usr/bin/env bash

# Restart all services
pkill -9 -f "ulauncher"
pkill -9 -f "waybar"
pkill -9 -f "albert"

albert &
ulauncher &
waybar &
