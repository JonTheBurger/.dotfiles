#!/usr/bin/sh
echo "Setting things up..."

# Install on separate lines so missing package doesn't cause failure
sudo apt-get install -y g++-8
sudo apt-get install -y gcc-8
sudo apt-get install -y gdb 
sudo apt-get install -y ccache
sudo apt-get install -y clang
sudo apt-get install -y clang-format
sudo apt-get install -y clang-tidy
sudo apt-get install -y clang-tools
sudo apt-get install -y cmake
sudo apt-get install -y cppcheck
sudo apt-get install -y curl
sudo apt-get install -y doxygen
sudo apt-get install -y graphviz
sudo apt-get install -y git
sudo apt-get install -y meld
sudo apt-get install -y ninja-build
sudo apt-get install -y silversearcher-ag
sudo apt-get install -y terminator
sudo apt-get install -y tig
sudo apt-get install -y valgrind
sudo apt-get install -y vim
sudo apt-get install -y zsh

# vim
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
cp -f .vimrc ~/.vimrc

# zsh
mkdir -p ~/.local/share/zsh/share
curl -L git.io/antigen > ~/.local/share/zsh/share/antigen.zsh
cp .profile ~/.profile
cp .zshrc ~/.zshrc

# gitconfig
cp .gitconfig ~/.gitconfig

# keyboard
sudo cp zz /usr/share/X11/xkb/symbols/zz
setxkbmap zz

# Get QtCreator
wget http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run
wget https://github.com/OneMoreGres/qtc-cppcheck/releases/download/4.6.0/QtcCppcheck-4.6.1-linux-x64.tar.gz
wget https://github.com/fpoussin/qtcreator-doxygen/releases/download/v0.4.6/libDoxygen-0.4.6-qtc4.5.x-x86_64.so
wget https://github.com/CJCombrink/SpellChecker-Plugin/releases/download/v1.2.0/SpellChecker-Plugin_v1.2.0_x64.tar.gz
