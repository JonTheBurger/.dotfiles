# source /opt/provisioners/style/config/.gdbinit
focus cmd
set history filename ~/.cache/gdb/history
set history save
# Do not step into includes matching
skip -gfi */*san_handlers*
skip -gfi */*googletest*
skip -gfi /usr/include/*
# Do not step into functions matching
skip -rfu ^.*::(capacity|c_str|data|empty|length|max_size|size|begin|end|cbegin|cend|rbegin|rend|crbegin|crend).*
skip -rfu ^boost::.*
skip -rfu ^std::.*
skip -rfu ^testing::.*

# FreeRTOS Desktop support
handle SIGUSR1 nostop noignore noprint
handle SIGALRM nostop noignore noprint
set startup-with-shell off

# Embedded
set mem inaccessible-by-default off

# Functions
define bsave
  save breakpoints ~/.cache/gdb/bkp.gdb
end

define bload
  source ~/.cache/gdb/bkp.gdb
end

# Hooks
define hook-stop
  # Obsessive refresh fixes TUI issues
  refresh
end
