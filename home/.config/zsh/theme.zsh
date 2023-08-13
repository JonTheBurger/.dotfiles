# For ls colors, See: https://geoff.greer.fm/lscolors/
local ret_status="%(?:%{$fg_bold[green]%}$:%{$fg_bold[red]%}$%s)"
PROMPT='%{$fg[blue]%}%B%c%b%{$reset_color%}:$(git_prompt_info)${ret_status}%{$reset_color%} '
#RPROMPT='[%*]'

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}(%{$fg_no_bold[red]%}%B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%{$fg_bold[cyan]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[yellow]%}*%{$reset_color%}"
