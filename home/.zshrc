#!/usr/bin/env zsh
# ======================================================================================
## Zsh
# ======================================================================================
# See: https://zsh.sourceforge.io/Doc/Release/Options.html
ZSH="$HOME/.config/zsh/.oh-my-zsh"
ZSH_CACHE_DIR="$HOME/.cache/oh-my-zsh"
ZSH_CUSTOM="$HOME/.config/zsh"
# See: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="awesomepanda" # Remove '$HOME/.config/zsh/theme.zsh' to use a built-in theme
# See: https://github.com/ohmyzsh/ohmyzsh/wiki/Settings
#ENABLE_CORRECTION="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode disable

# Custom Plugins
[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ] && git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
fpath+="$ZSH_CUSTOM/plugins/zsh-completions/src"

# See: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
# std @ $ZSH/plugins/, custom @ $ZSH_CUSTOM/plugins/
plugins=(
  colored-man-pages
  command-not-found
  dirhistory
  zsh-completions
)

# Auto-Setup
[ ! -d "$ZSH" ] && git clone https://github.com/ohmyzsh/ohmyzsh.git "${ZSH}"
source "$ZSH/oh-my-zsh.sh"

# ======================================================================================
## PATH & Scripts
# ======================================================================================
# Sourced in-order
local SCRIPTS=(
  $HOME/.local/bin/fzf-git.sh
  $HOME/.config/zsh/theme.zsh
  /usr/share/doc/fzf/examples/key-bindings.zsh
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
)
# Later paths = higher precedence
local PATH_PREFIX=(
  $HOME/bin
  $HOME/.local/bin
  $HOME/.cargo/bin
)
# Later paths = lower precedence
local PATH_SUFFIX=(
  /snap/bin
)
for script in "$SCRIPTS[@]"; do
  [ -f "$script" ] && source "$script"
done
for prefix in "$PATH_PREFIX[@]"; do
  [[ ! ":$PATH:" =~ ":$prefix:" ]] && [ -d "$prefix" ] && export PATH="$prefix:$PATH"
done
for suffix in "$PATH_SUFFIX[@]"; do
  [[ ! ":$PATH:" =~ ":$suffix:" ]] && [ -d "$suffix" ] && export PATH="$PATH:$suffix"
done

eval "$(zoxide init zsh)"

# ======================================================================================
## Environment
# ======================================================================================
export CMAKE_GENERATOR="Ninja"
export EDITOR='nvim'
export LANG=en_US.UTF-8
export VISUAL='nvim'
# https://github.com/zsh-users/zsh-autosuggestions#configuration
export ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd history completion)
[ -x "$(command -v fd)" ] && export FZF_DEFAULT_COMMAND='fd . --hidden --exclude ".git"'
# man pages
less_termcap[md]="${fg_bold[cyan]}"
# Fix comments being black foreground on black background
ZSH_HIGHLIGHT_STYLES[comment]="fg=245"

# ======================================================================================
## Functions & Aliases
# ======================================================================================
alias :q='exit'
alias bat='batcat'
alias buildtree='tree -I "CMakeFiles|Testing|external"'
alias c='z'
alias cat='bat -p'
alias copy='rsync -ahpruzvP'
alias getmode='stat -c %a'
alias goodbye='sudo apt update && sudo apt upgrade -y && sudo apt autoremove --purge -y && sudo shutdown now'
alias goto='cd -P'
alias gr='rg -S'
alias grep4='rg -S -uu'
alias l='eza -al --icons --git --color-scale -o'
alias ll='eza -al --color-scale -o --no-filesize --no-time --no-permissions'
alias look4='find . -iname'
alias mkpatch='git diff > ~/Desktop/$(basename $(pwd)).patch'
alias path='echo $PATH | sed "s#:#/\n#g"'
alias sodu='sudo --preserve-env=PATH env'
alias splitpath='sed "s#:#/\n#g"'
alias lzip='unzip -l'
alias ltar='tar tf'
function clone() {
  git clone git@bitbucket.org:msasafety/$@.git
}
function cls() {
  clear
  if [[ $TMUX ]]; then
    tmux clear-history
  else
    for _ in {1..300}; do
      echo
    done
  fi
  clear
}
function dkr-rmgrep() {
  docker rmi $(docker images --format '{{.Repository}}:{{.Tag}}' | grep $@)
}
function dkr-ims() {
  docker images --format '{{.Repository}}' | uniq | sort
}
function fsmon() {
  inotifywait -r -m -e modify . |
  while read p e f; do
    echo "$p$f modified"
  done
}
function fz() { cd $(zshz | sort -rh | awk '{print $NF}' | nl | fzf | awk '{print $NF}') }
function tailog() {
  tail -f "$@" | bat --paging=never -p -l log2
}
function mk() {
  if [ -f "bamboo.mk" ]; then
    make -f bamboo.mk "$@"
  elif [ -f "Makefile" ]; then
    make "$@"
  else
    ninja "$@"
  fi
}
function new() {
  copier copy ${HOME}/.new/$@ .
}
function uncrust() {
  uncrustify -c ~/.config/uncrustify.cfg -l C --mtime --replace --no-backup $@
}
function venv() {
  python3 -m venv .venv
  source .venv/bin/activate
}
function xmlfmt() {
  mv "$1" "$1.bkp"
  xmllint --format "$1.bkp" > "$1"
}
