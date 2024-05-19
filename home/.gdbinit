skip -gfi */*san_handlers*
skip -gfi */*googletest*
skip -gfi /usr/include/*
skip -rfu ^.*::(begin|end|cbegin|cend|rbegin|rend|crbegin|crend).*
skip -rfu ^.*::(capacity|c_str|data|empty|length|max_size|size).*
skip -rfu ^boost::.*
skip -rfu ^std::.*
skip -rfu ^testing::.*

set mem inaccessible-by-default off
set history filename ~/.gdb_history
set history save
focus cmd

define saveb
  save breakpoints ~/.cache/gdb/bkp.gdb
end
define loadb
  source ~/.cache/gdb/bkp.gdb
end

# Printers
source ~/Projects/jon/metl/tools/debugger/printers.py

# GUI
set $is_tui=1
# python import os
# python if os.path.exists(os.path.expanduser("~/.local/src/.gdbinit-gef.py")): gdb.execute("source ~/.local/src/.gdbinit-gef.py"); gdb.execute("tui disable"); gdb.execute("set $is_tui=0")
# python if os.path.exists(os.path.expanduser("~/.local/src/GEP/gdbinit-gep.py")): gdb.execute("source ~/.local/src/GEP/gdbinit-gep.py"); gdb.execute("tui disable"); gdb.execute("set $is_tui=0")

define hook-stop
 if ($is_tui == 1)
   refresh
 end
end
