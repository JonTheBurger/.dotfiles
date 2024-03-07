skip -gfi */ubsan_handlers_cxx.cpp
skip -gfi /usr/include/*
skip -rfu ^.*::(begin|end|rbegin|rend|cbegin|cend).*
skip -rfu ^boost::.*
skip -rfu ^std::.*
skip -rfu ^testing::.*

set mem inaccessible-by-default off
set history save
focus cmd
