#!/bin/bash

# chsh -s /usr/bin/zsh

sudo pacman -S
  ark \
  dolphin \
  greetd \
  greetd-tuigreet \
  gwenview \
  kdeconnect \
  kimageformats \
  kmonad \
  lazygit \
  libheif \
  noctalia \
  spotify-launcher \
  zoxide \
  thunderbird

# For kdeconnect
sudo ufw allow 1714:1764/tcp
sudo ufw allow 1714:1764/udp
sudo ufw reload

# /etc/greetd/config.toml
# command = "tuigreet --time --remember --remember-session --sessions /usr/share/wayland-sessions"
# sudo systemctl disable sddm.service  # Or gdm, lightdm, etc.
# sudo systemctl enable --now greetd.service

# neovide steam steam-devices gamescope cachyos-gaming-meta prismlauncher discord brave-bin nix uv qt6-svg
# lmms amdgpu_top

# remove
# plasma-integration packagekit-qt6
