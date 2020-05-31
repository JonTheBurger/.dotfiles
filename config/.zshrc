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
# highlights shell commands. MUST BE LAST PLUGIN
antigen bundle zsh-users/zsh-syntax-highlighting

### Load theme
antigen theme awesomepanda

### Tell Antigen that you're done.
antigen apply

