source (/home/jon/.local/bin/starship init fish --print-full-init | psub)
# function fish_prompt
#   set -l last_status $status
#
#   # Python virtualenv
#   if set -q VIRTUAL_ENV
#     set_color normal
#     echo -n '('(basename "$VIRTUAL_ENV")') '
#   end
#
#   # Directory (only last component)
#   set_color -o blue
#   echo -n (basename $PWD)
#   set_color normal
#
#   echo -n ':'
#
#   # Git branch and status
#   if git rev-parse --git-dir >/dev/null 2>&1
#     set -l branch (git branch --show-current 2>/dev/null)
#
#     # Branch name
#     set_color -o cyan
#     echo -n '('
#     set_color -o red
#     echo -n $branch
#     set_color normal
#
#     # Git status
#     set -l git_status_output (git status --porcelain 2>/dev/null)
#     set -l status_symbols ""
#
#     if test -n "$git_status_output"
#       # Check for different status types
#       if string match -q -r '^\?\?' -- $git_status_output
#         set status_symbols "$status_symbols?"
#       end
#       if string match -q -r '^.[M]' -- $git_status_output
#         set status_symbols "$status_symbols*"
#       end
#       if string match -q -r '^[MARC]' -- $git_status_output
#         set status_symbols "$status_symbols+"
#       end
#       if string match -q -r '^.D' -- $git_status_output
#         set status_symbols "$status_symbols-"
#       end
#       if string match -q -r '^R' -- $git_status_output
#         set status_symbols "$status_symbols»"
#       end
#       if string match -q -r '^U' -- $git_status_output
#         set status_symbols "$status_symbols="
#       end
#     end
#
#     # Check for ahead/behind
#     set -l ahead_behind (git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)
#     if test -n "$ahead_behind"
#       set -l ahead (echo $ahead_behind | awk '{print $1}')
#       set -l behind (echo $ahead_behind | awk '{print $2}')
#       if test $ahead -gt 0 -a $behind -gt 0
#         set status_symbols "$status_symbols⇕"
#       else if test $ahead -gt 0
#         set status_symbols "$status_symbols⇡"
#       else if test $behind -gt 0
#         set status_symbols "$status_symbols⇣"
#       end
#     end
#
#     # Check for stashed changes
#     if git rev-parse --verify refs/stash >/dev/null 2>&1
#       set status_symbols "$status_symbols\$"
#     end
#
#     if test -n "$status_symbols"
#       set_color -o yellow
#       echo -n $status_symbols
#       set_color normal
#     end
#
#     set_color -o cyan
#     echo -n ') '
#     set_color normal
#   end
#
#   # Prompt character ($ in green or red based on last command status)
#   if test $last_status -eq 0
#     set_color -o green
#   else
#     set_color -o red
#   end
#   echo -n '$ '
#   set_color normal
# end
