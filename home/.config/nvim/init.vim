""" Recycle Common Settings
source ~/.vimrc
autocmd filetype make setlocal noexpandtab
set lcs+=space:·
set list
set modelines=0 " Disable 'vim: set sw=2:' style lines, which break if you have something like ex: example text
set statusline=%F\ %l:%c
set termguicolors

""" Plugin Manager
source ~/.config/nvim/addon/vim-plug.vim

""" Colorscheme
" colorscheme space-vim-dark
" colorscheme codedark
lua require('vscode').load('dark')

""" Plugin Configuration
" source ~/.config/nvim/addon/cmake4vim.vim
source ~/.config/nvim/addon/clangd_extensions.lua
source ~/.config/nvim/addon/fzf.vim
source ~/.config/nvim/addon/nvim-lspconfig.lua
source ~/.config/nvim/addon/nvim-tree.lua
source ~/.config/nvim/addon/vim-commentary.vim
source ~/.config/nvim/addon/vimspector.vim
source ~/.config/nvim/addon/vimwiki.vim

""" Custom Functions
source ~/.config/nvim/fn/trim_whitespace.vim
source ~/.config/nvim/fn/toggle_hex.vim

""" Experimental
cnoreabbrev MkDebug execute '!make -f bamboo.mk debug'
cnoreabbrev Build execute '!cmake --build build'
cnoreabbrev JsonFmt execute '%!jq .'
cnoreabbrev FmtPy execute '!black %'
cnoreabbrev Black execute '!black %'
cnoreabbrev RRun execute '!cargo run'
cnoreabbrev RBuild execute '!cargo build'
cnoreabbrev RFmt execute '!rustfmt %'
function! Mk(target)
  " call system('mk ' . shellescape(a:target))
  :execute '!make ' . a:target
endfunction
command! -nargs=1 Mk call Mk(<q-args>)

