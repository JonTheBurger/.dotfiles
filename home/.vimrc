" https://vimhelp.org/options.txt.html
" Line Number
set relativenumber
set number
set nowrap

" Whitespace
set list
set lcs+=space:·
set listchars+=eol:\ 

" Theme
highlight SpecialKey ctermfg=darkgray

" Searching
set hlsearch
set ignorecase
set smartcase

" Document Spacing
set shiftwidth=2
set expandtab
set tabstop=2
set fixeol
set textwidth=120
set colorcolumn=120

" Host System Integration
set clipboard^=unnamed,unnamedplus
set mouse=a
syntax on

""" Extra Vim Settings
" NERDtree like setup
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15
map <leader>t :Lexplore<CR>

