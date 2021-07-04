#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get install -y \
      python3 \
      python3-pip \
      python3-venv
    sudo -Hu $SUDO_USER python3 -m venv /home/$SUDO_USER/.venv
elif [ -f "/etc/arch-release" ]; then
    echo "arch"
else
    echo "unsupported"
fi


