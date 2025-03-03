#!/usr/bin/env bash

# Restart all services
pkill -9 -f "ulauncher"
pkill -9 -f "waybar"

ulauncher &
waybar &
