source ~/.profile

### Auto setup
ANTIGEN_DIR=~/.local/share/zsh/share
if [[ ! -a ${ANTIGEN_DIR}/antigen.zsh ]]; then
    mkdir -p ${ANTIGEN_DIR}
    curl -L git.io/antigen > ${ANTIGEN_DIR}/antigen.zsh
fi
source ${ANTIGEN_DIR}/antigen.zsh

### Load the oh-my-zsh's library.
antigen use oh-my-zsh

### Bundles from the default repo (robbyrussell's oh-my-zsh).
# beautify directory listings by typing 'k'
antigen bundle supercrabtree/k
alias L='k -Ah'
# adds quote command
antigen bundle rand-quote
# adds supplementary git commands such as summary and effort
antigen bundle git-extras
# uses apt to search for similar commands
antigen bundle command-not-found
# history based completions with <right>
antigen bundle zsh-users/zsh-autosuggestions
# tab completions for various programs
antigen bundle zsh-users/zsh-completions
# highlights shell commands. MUST BE LAST PLUGIN.
antigen bundle zsh-users/zsh-syntax-highlighting

### Load the theme.
antigen theme bhilburn/powerlevel9k
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline user)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator history time command_execution_time)
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1

### Tell Antigen that you're done.
antigen apply

### Cheatsheet:
# d: directory history
# 1: go to listing 1
# L: pretty directory list
# Ctrl-X, Ctrl-E: edit command $EDITOR
# Ctrl-A: go to the beginning of line
# Ctrl-E: go to the end of line
# Alt-B: skip one word backward
# Alt-F: skip one word forward
# Ctrl-U: delete to the beginning of line
# Ctrl-K: delete to the end of line
# Alt-D: delete to the end of word
