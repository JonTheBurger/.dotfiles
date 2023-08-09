### zsh settings
setopt rmstarsilent
setopt nonomatch

# Aliases & Functions
alias :q='exit'
alias cls='for _ in {1..1000}; do echo; done; clear'
alias getmode='stat -c %a'
alias goto='cd -P'
alias gr='rg -S'
alias grep4='rg -S -uu'
alias look4='find . -iname'
alias sodu='sudo --preserve-env=PATH env'
alias bat='batcat'
alias copy='rsync -ahpruzvP'
alias mkpatch='git diff > ~/Desktop/$(basename $(pwd)).patch'
alias buildtree='tree -I "CMakeFiles|Testing|external"'
alias path='echo $PATH | sed "s#:#/\n#g"'
function mk() {
  if [ -f "bamboo.mk" ]; then
    make -f bamboo.mk "$@"
  elif [ -f "Makefile" ]; then
    make "$@"
  else
    ninja "$@"
  fi
}
function fsmon() {
  inotifywait -r -m -e modify . |
  while read p e f; do
    echo "$p$f modified"
  done
}
function xmlfmt() {
  mv "$1" "$1.bkp"
  xmllint --format "$1.bkp" > "$1"
}
function new() {
  copier copy ${HOME}/.new/$@ .
}
function dkr-rmgrep() {
  docker rmi $(docker images --format '{{.Repository}}:{{.Tag}}' | grep $@)
}
function dkr-ims() {
  docker images --format '{{.Repository}}' | uniq | sort
}

# Bookmarks
if [ -d "$HOME/.bookmarks" ]; then
  export CDPATH=".:$HOME/.bookmarks:/"
fi

# Variables
export CMAKE_GENERATOR="CodeBlocks - Ninja"

# Man Page Color
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)
export GROFF_NO_SGR=1         # For Konsole and Gnome-terminal

### Auto setup
ANTIGEN_DIR=~/.local/share/zsh/share
if [[ ! -a ${ANTIGEN_DIR}/antigen.zsh ]]; then
    mkdir -p ${ANTIGEN_DIR}
    curl -L git.io/antigen > ${ANTIGEN_DIR}/antigen.zsh
fi
source ${ANTIGEN_DIR}/antigen.zsh

### Load the oh-my-zsh's library
antigen use oh-my-zsh
# uses apt to search for similar commands
antigen bundle command-not-found
# history based completions with <right>
antigen bundle zsh-users/zsh-autosuggestions
# tab completions for various programs
antigen bundle zsh-users/zsh-completions
autoload -U compinit; compinit
# highlights shell commands. MUST BE LAST PLUGIN
antigen bundle zsh-users/zsh-syntax-highlighting

### Load theme
antigen theme awesomepanda

### Tell Antigen that you're done.
antigen apply

# Use fzf Ctrl+R command history, Ctrl+T file search, Alt+C cd to subdir
source /usr/share/doc/fzf/examples/key-bindings.zsh
source $HOME/.local/bin/fzf-git.sh

alias l='ls -AhFl'
alias ll='ls -AhFl --time-style="+%b %d %I:%M %p"'
PATH=~/.local/bin:$PATH

