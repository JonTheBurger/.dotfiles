" https://vimhelp.org/options.txt.html
" Line Number
set relativenumber
set number
set nowrap

" Whitespace
scriptencoding utf-8
set encoding=utf-8
set list
set listchars+=space:·
set listchars+=eol:\ 

" Theme
highlight SpecialKey ctermfg=darkgray

" Searching
set hlsearch
set ignorecase
set incsearch
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
map <space> <leader>
map <leader>e :Lexplore<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" function! SynStack()
"   if !exists("*synstack")
"     return
"   endif
"   echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
" endfunc
" nmap <F8> :call SynStack()<CR>
