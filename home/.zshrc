#!/usr/bin/env zsh
# source /opt/provisioners/style/config/.zshrc
# ======================================================================================
## Profiling: zsh -l --sourcetrace
# ======================================================================================
# zmodload zsh/zprof

# ======================================================================================
## Zsh: https://zsh.sourceforge.io/Doc/Release/Options.html
# ======================================================================================
autoload edit-command-line
zle -N edit-command-line
setopt auto_pushd
setopt hist_ignore_all_dups
setopt interactive_comments
setopt pushd_ignore_dups
setopt pushd_minus
setopt share_history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=$HISTSIZE
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# ======================================================================================
## PATH & Scripts: "should" be in .zshenv, but 1 file is easier. skip_global_compinit=1
# ======================================================================================
# Sourced in-order
local SCRIPTS=(
  /usr/share/doc/fzf/examples/key-bindings.zsh
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  $HOME/.local/share/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
)
# Later paths = higher precedence
local PATH_PREFIX=(
  /opt/SEGGER/JLink
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

# ======================================================================================
## Command Hooks
# ======================================================================================
[ -x "$(command -v devbox)" ] && eval "$(devbox global shellenv)"
unset XDG_DATA_DIRS
[ -x "$(command -v batcat)" ] && export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
[ -x "$(command -v batcat)" ] && export MANROFFOPT="-c"
[ -x "$(command -v dircolors)" ] && eval "$(dircolors -b)"
[ -x "$(command -v fd)" ] && export FZF_DEFAULT_COMMAND='fd . --hidden --exclude ".git"'
[ -x "$(command -v fzf)" ] && bindkey "^P" fzf-file-widget
[ -x "$(command -v starship)" ] && eval "$(starship init zsh)"
[ -x "$(command -v zoxide)" ] && eval "$(zoxide init zsh)"
[ -d "${HOME}/.local/share/zsh/zsh-completions" ] && fpath=(${HOME}/.local/share/zsh/zsh-completions/src $fpath)
[ -d "${HOME}/.local/share/zsh/zsh-autopair" ] && source "${HOME}/.local/share/zsh/zsh-autopair/autopair.zsh" && autopair-init
# [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
autoload -Uz compinit
if [[ ! -f ~/.zcompdump || ~/.zcompdump -ot ~/.zshrc ]]; then
  compinit
else
  compinit -Cu
fi

zmodload zsh/complist
command_not_found_handler() {
  if [[ -x /usr/lib/command-not-found ]]; then
    /usr/lib/command-not-found -- "$1"
    return $?
  elif [[ -x /usr/share/command-not-found/command-not-found ]]; then
    /usr/share/command-not-found/command-not-found -- "$1"
    return $?
  else
    printf "zsh: command not found: %s\n" "$1" >&2
    return 127
  fi
}

# ======================================================================================
## Theme
# ======================================================================================
ZSH_HIGHLIGHT_STYLES[comment]=fg=245                          # https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=yellow
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=yellow
ZSH_HIGHLIGHT_STYLES[path]=fg=blue,bold
# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
# Case insensitive match
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'
# Keybinds, check with 'showkey -a', see https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Modifying-Text
bindkey '^[e'  _expand_alias      # Alt+E
bindkey '^[b'  backward-word      # Alt+B
bindkey '^[f'  forward-word       # Alt+F
bindkey '^A'   beginning-of-line  # Ctrl+A
bindkey '^E'   end-of-line        # Ctrl+E
bindkey '^[[1;5D' backward-word   # Ctrl+Left
bindkey '^[[1;5C' forward-word    # Ctrl+Right
bindkey '^[[3;5~' kill-word       # Ctrl+Delete
bindkey '^[[3;3~' kill-word       # Alt+Delete
bindkey '^H'   backward-kill-word # Ctrl+Backspace & Ctrl+H
bindkey '^[^?' backward-kill-word # Alt+Backspace
bindkey '^[^H' backward-kill-line # Ctrl+Alt+Backspace
bindkey '^[[A' history-substring-search-up    # Up
bindkey '^[[B' history-substring-search-down  # Down
bindkey "$terminfo[kcuu1]" history-substring-search-up    # Up
bindkey "$terminfo[kcud1]" history-substring-search-down  # Down
bindkey -M menuselect '^[[Z' reverse-menu-complete  # Shift+Tab
bindkey '^X^e' edit-command-line  # Ctrl+X, Ctrl+E

# ======================================================================================
## Environment
# ======================================================================================
[ -x "$(command -v vcpkg)" ] && export VCPKG_ROOT="$(dirname $(realpath $(which vcpkg)))"
if [[ "$(uname -a)" == *WSL* ]]; then
  export DONT_PROMPT_WSL_INSTALL=1
  export XCURSOR_SIZE=24
  export WIN_USERNAME=$(/mnt/c/Windows/System32/cmd.exe "/c" "echo %USERNAME%" 2>/dev/null | tr -d '\r')
  export USERPROFILE=/mnt/c/Users/${WIN_USERNAME}
fi
export CMAKE_GENERATOR='Ninja'
export EDITOR='vim'
export GPG_TTY=$(tty)
export STARSHIP_LOG='error'

# ======================================================================================
## Functions & Aliases
# ======================================================================================
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias \$=''
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
alias :q='exit'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias bat='batcat'
alias bigvim='vim -c "syntax off"'
alias c='z'
alias d='dirs -v'
alias cat='bat -pP'
alias copy='rsync -ahpruzvP'
alias getmode='stat -c %a'
alias goodbye='sudo bash -c "export DEBIAN_FRONTEND=noninteractive; apt-get update && apt-get upgrade -y && apt-get autoremove --purge -y && shutdown now"'
alias goto='cd -P'
alias gr='rg -S'
alias grep4='rg -S -uu'
alias history='history 0'
alias k='fc -e -'
alias l='eza -l --icons --git --color-scale -o'
alias lg='lazygit'
alias ls='ls --color=auto -CF'
alias ll='eza -al --icons --git --color-scale -o'
alias ls='ls --color=auto'
alias lstar='tar tf'
alias lszip='unzip -l'
alias path='echo $PATH | sed "s#:#/\n#g"'
alias sodu='sudo --preserve-env=PATH env'
alias upd8='sudo bash -c "export DEBIAN_FRONTEND=noninteractive; apt-get update && apt-get upgrade -y && apt-get autoremove --purge"'
alias trust-ssh-keys="chmod 0700 ~/.ssh; chmod 0600 ~/.ssh/id_*; chmod 0644 ~/.ssh/id_*.pub; chmod 0600 ~/.ssh/config"

# ======================================================================================
## Functions & Aliases
# ======================================================================================
function :e() {
  nvim --cmd "cd $(dirname "$1")" "$1"
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
function onchange() {
  if [[ $# -lt 2 ]]; then
    echo "Error: onchange requires at least 2 arguments."
    echo "Usage: onchange <file_to_watch> <command> [args...]"
    return 1
  fi

  if [ "${1}" = "--verbose" ]; then
    local verbose=1
    shift
  fi
  [ -n "$verbose" ] && echo "-- [Hello]"

  local file_to_watch=$(realpath "$1")
  shift
  [ -n "$verbose" ] && echo "-- [Watching '${file_to_watch}']"

  # inotifywait -q -m -e create,close_write,moved_to . |
  inotifywait -q -m -e modify . |
  while read -r directory events filename; do
    fullpath=$(realpath "$filename")
    if [ "${fullpath}" = "${file_to_watch}" ]; then
      [ -n "$verbose" ] && echo "-- [Event: '${events}' @ '${file_to_watch}']"
      $@
    fi
  done
  [ -n "$verbose" ] && echo "-- [Goodbye]"
}
function uncrust() {
  uncrustify -c ~/.config/uncrustify.cfg -l C --mtime --replace --no-backup $@
}
function venv() {
  uv venv .venv
  source .venv/bin/activate
}
function xmlfmt() {
  mv "$1" "$1.bkp"
  xmllint --format "$1.bkp" > "$1"
}
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ======================================================================================
## Stop Profiling:
# ======================================================================================
# zprof
