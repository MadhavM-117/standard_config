#!/bin/bash


# Install the sketchybar app font
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.32/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf

# Get the icon map function
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.32/icon_map.sh -o ~/.config/sketchybar/plugins/icon_map_fn.sh

# If app icons aren't showing up, check in the icon_map_fn file to make sure the function name didn't change
echo "__icon_map \"\$1\"" >> ~/.config/sketchybar/plugins/icon_map_fn.sh
echo "echo \"\$icon_result\"" >> ~/.config/sketchybar/plugins/icon_map_fn.sh

# make the icon map fn executable
chmod +x ~/.config/sketchybar/plugins/icon_map_fn.sh

