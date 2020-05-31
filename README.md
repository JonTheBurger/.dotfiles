# Usage
1. Clone
```bash
cd $HOME
git clone https://github.com/JonTheBurger/.dotfiles.git
cd .dotfile
```

2. Distribute symlinks
`stow config`

# Background
Config file management via GNU [stow](https://www.gnu.org/software/stow/)
(`sudo apt install stow`). Stow allows users to create a "symlink farm", where
config files are merely symlinks to a centralized location (read: git repo).
This makes all edits trivial to sync across machines. Such files are located in
the `config` directory.

Some configuration files do not play well when copied between systems, or have
a common subset of text that can simply be appended. These live in the `append`
directory. `stow` does not handle these files. Instead, use:
`cat append/<file> >> <path-to-real-file>`

# Features
- Plugin manager auto-install for zsh and neovim
For these files, `zsh` uses the [antigen](https://github.com/zsh-users/antigen)
plugin manager, and `neovim` uses the [vim-plug](https://github.com/junegunn/vim-plug)
plugin manager. Rather than requiring the user to install the managers manually,
these dotfiles check the filesystems for plugin managers, then auto-install both
the and plugins and managers if not present. Note some plugins have additional 
dependencies (e.g. `deoplete` requires `mpack` for python), and curl is required
to download the plugin managers themselves.
- vim and neovim settings isolation
`.vimrc` is used as a bare minimum vim configuration. The intent is for vim to
remain minimal and snappy. Because no plugins are used, IDEs are able to source
this .vimrc and use its settings. init.vim sources this file and adds plugins,
providing a much more complete editing experinece.

