#!/bin/bash
if [[ $EUID -eq 0 ]]; then
    echo "This script must be run as a non-root user"
    exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    # Kubuntu-Backports (minor version bumps)
    sudo add-apt-repository -y ppa:kubuntu-ppa/backports
    sudo apt update

    sudo apt-get update -y
    # Core Desktop
    sudo apt-get install -y \
      breeze-icon-theme \
      fonts-hack \
      fonts-noto \
      kdebase-runtime \
      kde-config-cron \
      kde-config-gtk-style \
      kde-config-gtk-style-preview \
      kde-config-sddm \
      kio-extras \
      plasma-desktop \
      plasma-workspace \
      pulseaudio \
      sddm \
      systemsettings \
      udisks2 \
      upower \
      zip
    # Graphical Applications
    sudo apt-get install -y \
      ark \
      dolphin \
      dolphin-plugins \
      gwenview \
      kate \
      kcalc \
      kde-spectacle \
      konsole \
      ksysguard \
      kwin-addons \
      kwin-x11 \
      latte-dock \
      okular \
      partitionmanager \
      qt5-style-kvantum
elif [ -f "/etc/arch-release" ]; then
    echo "arch"
else
    echo "unsupported"
fi
