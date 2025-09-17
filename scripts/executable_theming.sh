#!/bin/bash

# Prerequisites
sudo pacman -S gtk-engine-murrine

# Setting up GTK themes
git clone https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme.git
cd ./Catppuccin-GTK-Theme/themes
./install.sh --tweaks macchiato macos outline float black -t mauve -l -s compact
cd ..
rm -rf Catppuccin-GTK-Theme

# Setting up icon themes and cursors
git clone https://github.com/vinceliuice/Colloid-icon-theme.git
cd ./Colloid-icon-theme
./install.sh -s catppuccin -t purple
cd cursors
./install.sh
cd ../..
rm -rf Colloid-icon-theme
