#!/bin/bash
if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get update
    sudo apt-get upgrade -y
    apt-cache --generate pkgnames \
      | grep --line-regexp --fixed-strings \
      -e apt-transport-https \
      -e batcat \
      -e ca-certificates \
      -e curl \
      -e fzf \
      -e git \
      -e git-lfs \
      -e htop \
      -e neovim \
      -e python3-pynvim\
      -e ripgrep \
      -e software-properties-common \
      -e stow \
      -e tig \
      -e tmux \
      -e tree \
      -e unzip \
      -e wget \
      -e vim \
      -e zsh \
    | xargs sudo apt-get install -y
    sudo snap install node --classic
elif [ -f "/etc/arch-release" ]; then
    echo "arch"
else
    echo "unsupported"
fi
