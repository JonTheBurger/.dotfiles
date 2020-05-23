""" Recycle Common Settings
source ~/.vimrc

""" Extra Vim Settings
" NERDtree like setup
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15
augroup ProjectDrawer
  autocmd!
  autocmd VimEnter * :Vexplore
augroup END

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
      \ 'python': ['~/.local/bin/pyls'],
      \ 'rust':   ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
      \ }

  nnoremap <leader>ld :call LanguageClient#textDocument_definition()<CR>
  nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
  nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>
  nnoremap <leader>lt :call LanguageClient#textDocument_typeDefinition()<CR>
  nnoremap <leader>lx :call LanguageClient#textDocument_references()<CR>
  nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
  nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
  nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
  nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
  nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
  
  nnoremap <leader>lr :call LanguageClient#textDocument_rename()<CR>
  :command Rename :call LanguageClient#textDocument_rename()

" Completion
  let g:deoplete#enable_at_startup = 1
  call deoplete#custom#option({
    \ 'auto_complete_delay': 100,
    \ 'smart_case': v:true,
    \ })

