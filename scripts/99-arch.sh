#!/bin/bash

sudo pacman -S
  ark \
  eza \
  yazi \
  zoxide \
  kdeconnect \
  kmonad \
  kimageformats \
  lazygit \
  libheif \
  spotify-launcher \
  thunderbird

# dms-shell

# For kdeconnect
sudo ufw allow 1714:1764/tcp
sudo ufw allow 1714:1764/udp
sudo ufw reload
