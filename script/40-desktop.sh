#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get install -y \
      dolphin \
      konsole \
      vim-gui-common \
      xclip
    sudo snap install chromium

    # VSCode
    if [ ! -f "/etc/apt/trusted.gpg.d" ]
      wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
      install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
      sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
      rm -f packages.microsoft.gpg
      apt-get update
      apt-get install code
    fi

elif [ -f "/etc/arch-release" ]; then
    echo "arch"
else
    echo "unsupported"
fi

