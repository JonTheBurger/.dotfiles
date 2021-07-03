#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get upgrade -y
    apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      fzf \
      git \
      git-lfs \
      htop \
      neovim \
      python3-pynvim\
      ripgrep \
      software-properties-common \
      stow \
      tig \
      tmux \
      tree \
      unzip \
      wget \
      vim \
      zsh
    snap install node --classic
elif [ -f "/etc/arch-release" ]; then
    echo "arch"
else
    echo "unsupported"
fi

