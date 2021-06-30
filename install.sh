#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    echo "Running ${SCRIPT_DIR}/install.sh"
    sudo -H -u $SUDO_USER bash -c 'echo "on behalf of ${USER}:${UID}"'
    stow config --no-folding
elif [ -f "/etc/arch-release" ]; then
    echo "Arch detected"
else
    echo "unsupported"
fi

