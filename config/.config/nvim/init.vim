""" Recycle Common Settings
source ~/.vimrc
set list
set lcs+=space:·
autocmd filetype make setlocal noexpandtab

""" Extra Vim Settings
" NERDtree like setup
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15
map <leader>t :Lexplore<CR>

""" Hex Editor
" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    silent :e " this will reload the file without trickeries
              "(DOS line endings will be shown entirely )
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction
map <leader>] :call ToggleHex()<CR>

""" Auto-Download vim-plug
let _is_first_plug_install = 0
if !filereadable(stdpath('data') . '/site/autoload/plug.vim')
  let _is_first_plug_install = 1
  execute '!curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

""" Install Plugins
call plug#begin(stdpath('data') . '/plugged')
  " Colorscheme
  Plug 'liuchengxu/space-vim-dark'
  " Language Client (+fuzzyfind dependency)
  Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
  Plug 'junegunn/fzf'
  " Completion
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

  " Auto-Install Plugins
  if _is_first_plug_install == 1
    execute 'PlugInstall'
  endif
call plug#end()

""" Configure
" Colorscheme
  set termguicolors
  colorscheme space-vim-dark

" Language Client
  set signcolumn=yes
  " Required for operations modifying multiple buffers like rename.
  set hidden
  let g:LanguageClient_serverCommands = {
      \ 'cpp':    ['clangd', '--background-index'],
      \ 'python': ['pyls'],
      \ 'rust':   ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
      \ }

  nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
  nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
  nnoremap <F2> :call LanguageClient#textDocument_definition()<CR>
  :command Dfn :call LanguageClient#textDocument_definition()<CR>
  :command Rename :call LanguageClient#textDocument_rename()
  :command Fmt :call LanguageClient#textDocument_formatting()<CR>
  :command Usages :call LanguageClient#textDocument_references()<CR>
  :command Doc :call LanguageClient_textDocument_documentSymbol()<CR>

" Completion
  let g:deoplete#enable_at_startup = 1
  call deoplete#custom#option({
    \ 'auto_complete_delay': 100,
    \ 'smart_case': v:true,
    \ })

