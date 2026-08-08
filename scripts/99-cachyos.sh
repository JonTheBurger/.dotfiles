#!/bin/bash

# chsh -s /usr/bin/zsh

sudo pacman -S \
  ark \
  curl \
  dolphin \
  brave-bin \
  flatpak \
  fuse2 \
  gwenview \
  kdeconnect \
  kimageformats \
  kitty \
  kmonad \
  lazygit \
  libheif \
  neovide \
  nix \
  qt6-svg \
  spotify-launcher \
  thunderbird \
  uv \
  zoxide

# For kdeconnect
sudo ufw allow 1714:1764/tcp
sudo ufw allow 1714:1764/udp
sudo ufw reload

# Games
sudo pacman -S \
  amdgpu_top \
  cachyos-gaming-meta \
  discord \
  gamescope \
  prismlauncher \
  steam \
  steam-devices

# lmms
