.dotfiles
=========
Configuration scripts and symlink farm for `$HOME` for setting up a keyboard
driven development environment. Contains configuration for:

- KDE
- NeoVim
- QtCreator
- TMux
- Vim
- Zsh

Currently supports `ubuntu-20.04`+.

Usage
=====
To install and run everything, use:

```bash
cd $HOME
git clone https://github.com/JonTheBurger/.dotfiles.git
cd .dotfiles
sudo ./install.sh
```

Additionally, you will probably want to update your git config:

```bash
git config --global user.name "Cools McRad"
git config --global user.email "cool@nice.com"
```

Layout
======
This section describes the `.dotfiles` repository's layout.

`script`
--------
Contains scripts prefixed by number to denote execution order:

- `10`: Basic utilities suitable for a headless server.
    - `10-base.sh`:
        - Network I/O { curl, wget }
        - Apt { apt-transport-https, ca-certificates, software-properties-common }
        - Development { git+lfs+tig, htop, neovim+vim, zsh }
        - Filesystem { fzf, stow, tree, unzip }
- `20`: Development tools intended for a specific language or project.
    - `20-c++.sh`:
        - System GCC+GDB
        - Clang + Tools (latest)
        - Build Systems { cmake (latest), ninja }
        - Analyzers { cppcheck, valgrind }
        - Docs { doxygen }
    - `20-python.sh`:
        - System Python3
        - Pip
        - Venv
- `30`: Desktop environment and bare minimum applications to give a proper
    desktop experience.
    - `30-kde.sh`: KDE Plasma Desktop with different presets than kubuntu
        - dolphin
        - gwenview
        - kate
        - konsole
        - ksysguard
        - kvantum
        - latte-dock
        - okular
        - partitionmanager
- `40`: Graphical tools suitable for installing on any given desktop
    environment, organized by use. (Installing something like `firefox` before
    a DE on ubuntu will drag in the entire gnome shell.)
    - `40-desktop.sh`: Language Agnostic Programming Tools
        - chromium
        - dolphin
        - konsole
        - vim clipboard support
        - vscode
        - xmodmap (with CapsLock as vim-style Hyper)
- `50`: Desktop environment configuration. Must be run before a desktop session
    is running (e.g. Desktop saves settings upon shutdown).
- `99`: Desktop environment configuration. Must be run after a desktop session
    is already running (e.g. to use a Desktop's DBus API).
    - `99-kde-theme.sh`: 
        - Kröhnkite
        - Latte Dock

`home`
------
Mirrors the user's `$HOME` directory. Only files are symlinked
(`stow --no-folding`), not folders.

`docs`
------
Graphics for markdown gallery.

Shortcuts
=========

NeoVim
------

TMux
----

QtCreator
---------

KDE
---

Gallery
=======
