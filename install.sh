#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
home="/home/$SUDO_USER"

# curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
# chmod u+x nvim.appimage
# curl -LO https://github.com/junegunn/fzf/releases/latest/download/0.42.0/fzf-0.42.0-linux_arm64.tar.gz

################################################################################
# Check Operating System; Perform OS Specific Prerequisite Setup
################################################################################
if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get install -y stow
    os="ubuntu"
elif [ -f "/etc/arch-release" ]; then
    os="arch"
    exit 1
else
    echo "ERROR: Unsupported Operating System"
    exit 1
fi

################################################################################
# Parse Arguments
################################################################################
function usage() {
  echo "USAGE: ./install.sh"
}

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -h|--help)
            usage
            exit 0
            ;;
        *) # unknown option
            usage
            exit 0
            ;;
    esac
done

################################################################################
# Run Installation
################################################################################
# Prompt Stow
read -p "Stow to $home? [Y/n] " -n 1 -r
echo # move to a new line
[[ $REPLY =~ ^[Yy]$ ]] && RUN_STOW=1

# Stow
if [ "$RUN_STOW" ]; then
    echo "symlink farming"
    stow home --no-folding
fi

# Run all scripts in `script`
SCRIPTS="$SCRIPT_DIR/script/*"
for s in $SCRIPTS
do
    filename=$(basename $s)

    # 99-* scripts are meant to be run in a desktop environment
    if case ${filename} in 99*) ;; *) false;; esac; then
        # Check if a Desktop Session is running
        if [ ! -z "$DESKTOP_SESSION" ]; then
            # If not, we exit
            echo "No Desktop Running, skipping 99-* scripts"
            echo "Reboot your system! Check '$SCRIPT_DIR/script/99-*' for desktop setups!"
            exit 0
        fi
    fi

    # Prompt Script
    unset RUN_SCRIPT
    read -p "Run ${filename}? [Y/n] " -n 1 -r
    echo # move to a new line
    [[ $REPLY =~ ^[Yy]$ ]] && RUN_SCRIPT=1

    # Execute Script
    if [ "$RUN_SCRIPT" ]; then
        echo "Runnning $s"
        $s
    fi
done
