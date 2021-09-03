#!/bin/bash
if [[ $EUID -eq 0 ]]; then
    echo "This script must be run as a non-root user"
    exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get install -y \
      dolphin \
      dolphin-plugins \
      konsole \
      vim-gui-common \
      x11-xserver-utils \  # for xmodmap
      xclip \
      yakuake
    sudo snap install chromium

    # Remap CapsLock to Hyper
    if grep -q xmodmap "~/.profile"; then
        echo "xmodmap ~/.Xmodmap" >> "~/.profile"
    fi

    # VSCode
    if [ ! -f "/etc/apt/trusted.gpg.d" ]
        # wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        # sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
        # sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        # rm -f packages.microsoft.gpg
        # sudo apt-get update
        # sudo apt-get install code
        sudo snap install code --classic
    fi

elif [ -f "/etc/arch-release" ]; then
    echo "arch"
else
    echo "unsupported"
fi
