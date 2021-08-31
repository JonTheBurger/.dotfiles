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
    # Core Desktop
    apt-get install -y \
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
    apt-get install -y \
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
