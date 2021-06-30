#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    # Kubuntu-Backports (minor version bumps)
    add-apt-repository -y ppa:kubuntu-ppa/backports
    apt update

    apt-get update -y
    apt-get install -y \
      kubuntu-desktop \
      sddm
    apt-get install -y \
      kwin-addons \
      kwin-x11 \
      latte-dock \
      qt5-style-kvantum
elif [ -f "/etc/arch-release" ]; then
    echo "arch"
else
    echo "unsupported"
fi

