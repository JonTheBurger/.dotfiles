#!/bin/bash
if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get install -y \
      python3 \
      python3-pip \
      python3-venv
    python3 -m venv ~/.venv
elif [ -f "/etc/arch-release" ]; then
    echo "arch"
else
    echo "unsupported"
fi
