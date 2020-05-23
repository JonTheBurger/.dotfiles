#!/usr/bin/bash
echo "SETTING UP..."

# Basic
cp .gitconfig ~/.gitconfig
cp .vimrc ~/.vimrc
cp .Xmodmap ~/.Xmodmap
cp .zshrc ~/.zshrc
cat .profile >> ~/.profile

# nvim
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim/init.vim

# QtCreator
mkdir -p ~/.config/QtProject/qtcreator/styles
cp Crystal.xml ~/.config/QtProject/qtcreator/styles/Crystal.xml

echo "SUCCESS!"

