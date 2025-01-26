.dotfiles
=========

This repository contains all of the automation required to set up a new
development environment with my preferred settings.

**Requirements:**

The supported environments reflect the environments on which I typically work:

- Ubuntu Server (or Desktop) 22.04+

**Usage:**

```bash
# Get Config
# git@github.com:JonTheBurger/.dotfiles.git ~/.dotfiles
git clone https://github.com/JonTheBurger/.dotfiles.git ~/.dotfiles
# Install stow & friends
cd ~/.dotfiles
./scripts/10-cli.sh
# Farm Soft Links
make stow
```

--------------------------------------------------------------------------------

Scripts
-------

The scripts in this directory are designed to be user-friendly, and naively
executable using `./scripts/*`. Some notable features include:

**Safe:**

Each step run by a script is designed to be safe. Scripts shall:

- Print a description and rationale of the changes they are about to enact.
- Preemptively alert users of any potentially destructive change/modification.
- Allow the user to skip any given step.
- Be idempotent (may be rerun for an equivalent output).
- Run with minimal viable permissions (prefer user installs to system installs).
- Follow the [Filesystem Hierarchy Standard] conventions.
- Demonstrate copious polish (pass `shellcheck` and `shfmt`, contain
  documentation), in part so they can act as a reference for future Jon.

**Ordered:**

The scripts in this directory are numbered. Higher numbered scripts may have a
dependency on lower numbered scripts, but scripts of the same numeric prefix
may be run in any order. The numbers approximately mean:

- `10`: Development tools useful in a terminal-only environment (servers, wsl).
- `20`: Setup for development using individual programming languages (no gui).
- `30`: Installers for a particular graphical Linux Desktop Environment.
- `40`: Graphical application installers, irrespective of desktop.
- `99`: Scripts that run after a reboot or other manual steps.

**Interactive:**

Because these scripts are explicitly designed to _not_ run headlessly, they
offer a quality user experience (at least relative to many bash scripts):

- Colorful!
- Can be silenced with `--quiet` for experienced users!
- Can be rendered chattier with `--verbose` for foolish jontheburgers!
- Accept piping yes a la `yes | ./scripts/10-cli.sh`, provided the `sudo`
  password has been recently provided.

Simply run with (e.g.) `./script/10-cli.sh`!

--------------------------------------------------------------------------------

Home
----

**Background:**

If you know what dotfiles are, you can skip this.

Conveniently, many applications store user-specific configuration files within
the user's `$HOME` directory (or `%UserProfile%` / `$env:UserProfile` for
Windows, maybe `%AppData%`). We could copy paste our files between development
boxes, but the hallmark of any good `~/.dotfiles` is their ability to easily
sync between machines. This is achieved by creating _soft-links_ from the
config files' real locations on disk back to a centralized git repository
containing the original copies. A soft-link is like a shortcut - it's a
symbolic link that refers to a location on disk (incidentally, if the original
file is removed a broken link persists). Consider the following example:

```bash
$ pwd
/home/vagrant
$ ls -al | grep '\->'
lrwxrwxrwx  1 vagrant vagrant    25 Aug 12  2022 .tmux.conf -> .dotfiles/home/.tmux.conf
lrwxrwxrwx  1 vagrant vagrant    21 Aug 12  2022 .vimrc -> .dotfiles/home/.vimrc
lrwxrwxrwx  1 vagrant vagrant    21 Aug 12  2022 .zshrc -> .dotfiles/home/.zshrc
$ # "Look 'ma, no copies!" / "oops, all soft-links!"
```

`~/.tmux.conf`, `~/.vimrc`, and `~/.zshrc` all point back to the `.dotfiles`
repo, meaning a `git pull` will automatically update our configs to the latest
version! This is known as "symlink farming". Note that _we do not soft-link any
directories_. To automate this process, we use GNU `stow` with the
`--no-folding` flag. This flag _creates_ missing directories instead of
soft-linking them - we prefer this because otherwise any other files created in
those directories would appear in our `.dotfiles` repo.

**Contents:**

This directory contains the files that will be soft-linked under `$HOME`. Simply
`cd ~/.dotfiles && make stow` to distribute the links. This may be rerun any
number of times.

Notably the following programs are configured (among others):

- `nvim`: Fully Lua, LazyNvim config with LSP, DAP, Telescope, and more.
- `zsh`: Bash shell alternative with support for fuzzy completions & history.
- `tmux`: Shell multiplexer that support tabs & splits in any terminal emulator.
- `git`: For all of those neat aliases.
- `vim`: For when you want that classic vanilla Vim experience.
- `Xmodmap`: For rebinding CapsLock to ISO-3 Hyper, enabling HJKL navigation.
- `ideavimrc`: Because when using a JetBrains IDE, you still wish you were in vim.
- `vsvim`: Because when using Visual Studio 20XX, you still wish you were in vim.

...

- `kitty`: GPU-rendered terminal emulator.
- `alacritty`: GPU-rendered terminal emulator, but also on Windows.
- `QtCreator`: Color schemes and keyboard shortcuts. (vim mode commands!!)
- `Dolphin`: KDE's feature-rich file manager.
- `Latte`: KDE-based dock.
- `Konsole`: KDE's default terminal emulator. (Gathering cobwebs)
- `Yakuake`: Quake-style drop-down terminal emulator for KDE. (Gathering cobwebs)

--------------------------------------------------------------------------------

[Filesystem Hierarchy Standard]: https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html

<details>
<summary markdown="span">TODO</summary>

- qq keyboard layout
- zshrc dependency installer
- updatedb exclude /mnt & /media
- neocmake
- if grep -q xmodmap "~/.profile"; then echo "xmodmap ~/.Xmodmap" >> "~/.profile" fi
- vim commentary bash #
- sudo snap install node --channel=22/stable --classic
- npm config set prefix '~/.local'
- npm install --global yarn
- konsave
- vlink
- curl https://sh.rustup.rs -sSf | sh -s -- -y
    - rustup component add rust-analyzer
- https://unix.stackexchange.com/questions/747748/map-c-s-a-hjkl-to-arrow-keys-with-xkb-map
- marksman, other LSP (autoinstall?) (vimwiki remove)

</details>
