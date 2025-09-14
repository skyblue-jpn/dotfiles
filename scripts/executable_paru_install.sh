#!/bin/bash

# Install paru if not already installed
# Check if paru is installed
if ! command -v paru &>/dev/null; then
  # Install paru
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  cd ..
  rm -rf paru
fi
# Update system and all packages including AUR packages
paru -Syyu --noconfirm
# Install desired packages from ./pkglist.txt
paru -S --needed - <./pkglist.txt
# Clean up any unnecessary packages
paru -Rns $(paru -Qdtq) --noconfirm
# Clear the package cache
paru -Sc --noconfirm
# End of script
