#!/usr/bin/bash
echo "SETTING UP..."

# Basic
cp .gitconfig ~/.gitconfig
cp .vimrc ~/.vimrc
cp .Xmodmap ~/.Xmodmap
cp .zshrc ~/.zshrc
cat .profile >> ~/.profile

# QtCreator
mkdir -p ~/.config/QtProject/qtcreator/styles
cp Crystal.xml ~/.config/QtProject/qtcreator/styles/Crystal.xml

echo "SUCCESS!"

