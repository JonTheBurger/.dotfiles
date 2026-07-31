#!/bin/bash

sudo pacman -S
  eza \
  yazi \
  zoxide \
  kdeconnect \
  kmonad \
  lazygit \
  thunderbird

# For kdeconnect
sudo ufw allow 1714:1764/tcp
sudo ufw allow 1714:1764/udp
sudo ufw reload
