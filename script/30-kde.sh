#!/bin/bash
if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    # Kubuntu-Backports (minor version bumps)
    sudo add-apt-repository -y ppa:kubuntu-ppa/backports
    sudo apt update

    sudo apt-get update -y
    # Core Desktop
    apt-cache --generate pkgnames \
      | grep --line-regexp --fixed-strings \
      -e breeze-icon-theme \
      -e fonts-hack \
      -e fonts-noto \
      -e kdebase-runtime \
      -e kde-config-cron \
      -e kde-config-gtk-style \
      -e kde-config-gtk-style-preview \
      -e kde-config-sddm \
      -e kio-extras \
      -e plasma-desktop \
      -e plasma-workspace \
      -e pulseaudio \
      -e sddm \
      -e systemsettings \
      -e udisks2 \
      -e unzip \
      -e upower \
      -e zip \
    | xargs sudo apt-get install -y

    # Graphical Applications
    apt-cache --generate pkgnames \
      | grep --line-regexp --fixed-strings \
      -e ark \
      -e bismuth \
      -e dolphin \
      -e dolphin-plugins \
      -e gwenview \
      -e kate \
      -e kcalc \
      -e kde-spectacle \
      -e konsole \
      -e ksysguard \
      -e kwin-addons \
      -e kwin-x11 \
      -e latte-dock \
      -e okular \
      -e partitionmanager \
      -e qt5-style-kvantum \
    | xargs sudo apt-get install -y
elif [ -f "/etc/arch-release" ]; then
    echo "arch"
else
    echo "unsupported"
fi
