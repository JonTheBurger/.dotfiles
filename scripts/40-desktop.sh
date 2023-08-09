#!/bin/bash
if [ -f "/etc/apt/sources.list" ]; then
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get install -y \
      dolphin \
      dolphin-plugins \
      kitty \
      konsole \
      fonts-noto-color-emoji \
      vim-gui-common \
      x11-xserver-utils \
      xclip \
      yakuake
    sudo snap install chromium

    # Remap CapsLock to Hyper
    if grep -q xmodmap "~/.profile"; then
        echo "xmodmap ~/.Xmodmap" >> "~/.profile"
    fi

    # VSCode
    if [ ! -f "/etc/apt/trusted.gpg.d" ]; then
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

cat > /etc/fonts/local.conf <<EOF
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>

 <alias>
   <family>sans-serif</family>
   <prefer>
     <family>Noto Sans</family>
     <family>Noto Color Emoji</family>
     <family>Noto Emoji</family>
     <family>DejaVu Sans</family>
   </prefer>
 </alias>

 <alias>
   <family>serif</family>
   <prefer>
     <family>Noto Serif</family>
     <family>Noto Color Emoji</family>
     <family>Noto Emoji</family>
     <family>DejaVu Serif</family>
   </prefer>
 </alias>

 <alias>
  <family>monospace</family>
  <prefer>
    <family>Noto Mono</family>
    <family>Noto Color Emoji</family>
    <family>Noto Emoji</family>
   </prefer>
 </alias>

</fontconfig>
EOF

