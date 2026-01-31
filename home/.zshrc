#!/usr/bin/env zsh
# source /opt/provisioners/style/config/.zshrc
# ======================================================================================
## Profiling: zsh -l --sourcetrace
# ======================================================================================
# zmodload zsh/zprof

# ======================================================================================
## Zsh: https://zsh.sourceforge.io/Doc/Release/Options.html
# ======================================================================================
export EDITOR='nvim'
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
  /usr/share/fzf/shell/key-bindings.zsh
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
fzcmakec-widget() {
  ~/.local/bin/fzcmakec
  zle reset-prompt
}
zle -N fzcmakec-widget
fzcmakeb-widget() {
  ~/.local/bin/fzcmakeb
  zle reset-prompt
}
zle -N fzcmakeb-widget

[ -x "$(command -v devbox)" ] && eval "$(devbox global shellenv)"
# unset XDG_DATA_DIRS
[ -x "$(command -v bat)" ] && export MANPAGER="sh -c 'col -bx | bat -l man -p'"
[ -x "$(command -v bat)" ] && export MANROFFOPT="-c"
[ -x "$(command -v dircolors)" ] && eval "$(dircolors -b)"
[ -x "$(command -v fd)" ] && export FZF_DEFAULT_COMMAND='fd . --hidden --exclude .git'
[ -x "$(command -v fd)" ] && export FZF_CTRL_T_COMMAND='fd . -t file --hidden --exclude .git'
[ -x "$(command -v fzf)" ] && bindkey "^P" fzf-file-widget
[ -x "$(command -v fzf)" ] && bindkey "^T" fzcmakec-widget
[ -x "$(command -v fzf)" ] && bindkey "^Y" fzcmakeb-widget
[ -x "$(command -v starship)" ] && eval "$(starship init zsh)"
[ -x "$(command -v zoxide)" ] && eval "$(zoxide init zsh)"
[ -d "${HOME}/.local/share/zsh/zsh-completions" ] && fpath=(${HOME}/.local/share/zsh/zsh-completions/src $fpath)
[ -d "${HOME}/.local/share/zsh/completions" ] && fpath=(${HOME}/.local/share/zsh/completions $fpath)
[ -d "${HOME}/.local/share/zsh/zsh-autopair" ] && source "${HOME}/.local/share/zsh/zsh-autopair/autopair.zsh" && autopair-init
[ -f "${HOME}/.local/bin/fzf-git.sh" ] && source "${HOME}/.local/bin/fzf-git.sh"
# [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
autoload -Uz compinit
if [[ ! -f ~/.zcompdump || ~/.zcompdump -ot ~/.zshrc ]]; then
  compinit
else
  compinit -Cu
fi
[ -x "$(command -v jj)" ] && eval "$(jj util completion zsh)"

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

python_venv() {
  local MYVENV=./.venv
  # when you cd into a folder that contains $MYVENV
  [[ -d $MYVENV ]] && source $MYVENV/bin/activate > /dev/null 2>&1
  # when you cd into a folder that doesn't
  [[ ! -d $MYVENV ]] && deactivate > /dev/null 2>&1
}
autoload -U add-zsh-hook
add-zsh-hook chpwd python_venv
python_venv

# ======================================================================================
## Theme
# ======================================================================================
if [[ -n "${ZSH_HIGHLIGHT_STYLES+x}" ]]; then
  ZSH_HIGHLIGHT_STYLES[comment]=fg=245                          # https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=yellow
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=yellow
  ZSH_HIGHLIGHT_STYLES[path]=fg=blue,bold
fi
# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
# Case insensitive match
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'
# Keybinds, check with 'showkey -a', see https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Modifying-Text
bindkey '^[e'  _expand_alias      # Alt+E
bindkey '^[b'  backward-word      # Alt+B
bindkey '\e[1~' beginning-of-line # Home
bindkey '\e[4~' end-of-line       # End
bindkey '^[[H' beginning-of-line # Home
bindkey '^[[F' end-of-line       # End
bindkey '^[f'  forward-word       # Alt+F
bindkey '^A'   beginning-of-line  # Ctrl+A
bindkey '^E'   end-of-line        # Ctrl+E
bindkey '^[[1;5D' backward-word   # Ctrl+Left
bindkey '^[[1;5C' forward-word    # Ctrl+Right
bindkey "^[[3~" delete-char       # Delete
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
  if [[ ! -f "${HOME}/.local/share/.wsl_env" ]]; then
    echo "WIN_USERNAME=$(/mnt/c/Windows/System32/cmd.exe "/c" "echo %USERNAME%" 2>/dev/null | tr -d '\r')" > "${HOME}/.local/share/.wsl_env"
  fi

  export $(grep -v '^#' "${HOME}/.local/share/.wsl_env" | xargs -d '\n')
  export DONT_PROMPT_WSL_INSTALL=1
  export XCURSOR_SIZE=24
  export USERPROFILE=/mnt/c/Users/${WIN_USERNAME}
fi
export CMAKE_BUILD_TYPE='Debug'
export CMAKE_COLOR_DIAGNOSTICS='ON'
export CMAKE_EXPORT_COMPILE_COMMANDS='ON'
export CMAKE_GENERATOR='Ninja'
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
alias :qa='tmux kill-window'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias bigvim='vim -c "syntax off"'
alias c='z'
alias cat='bat -pP'
alias copy='rsync -ahpruzvP'
alias d='dirs -v'
alias e="$EDITOR"
alias f='y'
alias getmode='stat -c %a'
alias goodbye='sudo zsh -c "upd8 && shutdown now"'
alias goto='cd -P'
alias gr='rg -S'
alias grep4='rg -S -uu'
alias history='history 0'
alias icat='kitten icat'
alias k='fc -e -'
alias l='eza -l --icons --git --color-scale -o'
alias lg='lazygit'
alias ls='ls --color=auto -CF'
alias ll='eza -al --icons --git --color-scale -o'
alias ls='ls --color=auto'
alias lstar='tar tf'
alias lszip='unzip -l'
alias memcheck='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes'
alias mtime='stat -c %Y'
alias path='echo $PATH | sed "s#:#/\n#g"'
alias splitlines="rg -oP '\S+'"
alias sodu='sudo --preserve-env=PATH env'
alias upd8='sudo bash -c "export DEBIAN_FRONTEND=noninteractive; apt-get update && apt-get upgrade -y && apt-get autoremove --purge"'
alias trust-ssh-keys="chmod 0700 ~/.ssh; chmod 0600 ~/.ssh/id_*; chmod 0644 ~/.ssh/id_*.pub; chmod 0600 ~/.ssh/config"
alias x=trash
alias zj=zellij
alias zja=zellij attach --create

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
function cmakeinstall() {
  cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_TESTING=OFF
  cmake --build build
  sudo cmake --install build
}
function dkr-rmgrep() {
  docker rmi $(docker images --format '{{.Repository}}:{{.Tag}}' | grep $@)
}
function dkr-ims() {
  docker images --format '{{.Repository}}' | uniq | sort
}
function drmi() {
  docker images | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $3 }' | xargs -r docker rmi --force
}
function fkill() {
  local pid
  if [ "$UID" != "0" ]; then
    pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
  else
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  fi

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}
function fsmon() {
  inotifywait -r -m -e modify . |
  while read p e f; do
    echo "$p$f modified"
  done
}
function tailog() {
  tail -f "$@" | bat --paging=never -p -l log
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
function lazy_load_nvm() {
  # https://github.com/nvm-sh/nvm/issues/2724
  unset -f node npm nvm
  export NVM_DIR=~/.nvm
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
}
function node() {
  lazy_load_nvm
  node $@
}
function npm() {
 lazy_load_nvm
 npm $@
}
function nvm() {
  lazy_load_nvm
  nvm $@
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
  if [ ! -d .venv ]; then
    uv venv .venv
  fi
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
