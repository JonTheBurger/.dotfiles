""" Recycle Common Settings
source ~/.vimrc
set list
set lcs+=space:·
autocmd filetype make setlocal noexpandtab
set statusline=%F\ %l:%c
" Disable 'vim: set sw=2:' style lines, which break if you have something like ex: example text
set modelines=0

""" Auto-Download vim-plug
let _is_first_plug_install = 0
if !filereadable(stdpath('data') . '/site/autoload/plug.vim')
  let _is_first_plug_install = 1
  if has("win64")
    execute '!curl -fLo %USERPROFILE%/AppData/Local/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  else
    execute '!curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  endif
endif

""" Install Plugins
call plug#begin(stdpath('data') . '/plugged')
  " Colorscheme
  Plug 'liuchengxu/space-vim-dark'
  " CHADTree
  Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
  " EasyMotion
  Plug 'easymotion/vim-easymotion'
  " Fuzzy Finder
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  " Completion + LSP | :CocInstall coc-clangd | :CocInstall coc-cmake | :CocInstall coc-python | :CocInstall coc-rust-analyzer
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " C++ Semantic Highlighting
  Plug 'jackguo380/vim-lsp-cxx-highlight'
  " vim-dispatch (CMake status in background)
  Plug 'tpope/vim-dispatch'
  " Comment out lines
  Plug 'tpope/vim-commentary'
  " Surround selections with quotes, parens, etc.
  Plug 'tpope/vim-surround'
  " CMake
  Plug 'ilyachur/cmake4vim'
  " Google Test
  Plug 'alepez/vim-gtest'
  " Debug (:VimspectorInstall vscode-cpptools)
  Plug 'puremourning/vimspector'
  " Ansi escape sequences with :ColorHighlight
  Plug 'chrisbra/Colorizer'
  " Vimwiki
  Plug 'vimwiki/vimwiki'

  " Auto-Install Plugins
  if _is_first_plug_install == 1
    execute 'PlugInstall'
  endif
call plug#end()

""" Configure
" Colorscheme
  set termguicolors
  colorscheme space-vim-dark

""" FZF
let $FZF_DEFAULT_COMMAND='rg --files --hidden -g "!.git"'
:map <C-P> :FZF<CR>

" command! -bang -nargs=? -complete=dir PFiles
"       \ call fzf#vim#grep(<q-args>, {'options': ['--hidden', '-g', '!.git']}, <bang>0)
" :map <C-p> :PFiles<CR>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case --sort path --hidden -g "!.git" -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
:map <C-K> :RG<CR>
" :map <C-S-k> :Rg<CR>

""" Coc
source ~/.config/nvim/coc_settings.vim

""" CHADTree
nnoremap <leader>t <cmd>:CHADopen<cr>
let g:chadtree_settings = {
  \ 'keymap.toggle_version_control': [';'],
  \ 'keymap.change_dir': ['B'],
  \ 'theme.icon_glyph_set': 'ascii',
  \ 'view.window_options.number': v:true,
  \ 'view.window_options.relativenumber': v:true
  \ }

""" vim-commentary
" Ctrl+/ toggle comment
:map <C-_> gcc

"nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
  "nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
  "nnoremap <F2> :call LanguageClient#textDocument_definition()<CR>
  ":command Dfn :call LanguageClient#textDocument_definition()<CR>
  ":command Rename :call LanguageClient#textDocument_rename()
  ":command Fmt :call LanguageClient#textDocument_formatting()<CR>
  ":command Usages :call LanguageClient#textDocument_references()<CR>
  ":command Doc :call LanguageClient_textDocument_documentSymbol()<CR>
  ":command Fix ????? :execute "normal \<Plug>coc-fix-current()"

""" clangd
cnoreabbrev A CocCommand clangd.switchSourceHeader

""" cmake4vim
cnoreabbrev Target CMakeSelectTarget
cnoreabbrev Tgt FZFCMakeSelectTarget
let g:cmake_build_type = 'Debug'
let g:cmake_compile_commands = 1
let g:cmake_compile_commands = 1
let g:cmake_compile_commands_link = './build/compile_commands.json'
let g:cmake_project_generator = 'Ninja'
let g:cmake_vimspector_support = 1
let g:cmake_build_path_pattern = [ "build/%s", "g:cmake_build_type" ]
let g:cmake_vimspector_default_configuration = {
            \ 'adapter': 'vscode-cpptools',
            \ 'configuration': {
                \ 'request': 'launch',
                \ 'cwd': '${workspaceRoot}',
                \ 'MIMode': 'gdb',
                \ 'setupCommands': [
                \     {
                \         'description': 'Enable pretty-printing for gdb',
                \         'text': '-enable-pretty-printing'
                \     }
                \ ],
                \ 'args': [],
                \ 'program': ''
                \ }
            \ }

""" gtest
cnoreabbrev RunTest GTestRunUnderCursor
cnoreabbrev NewTest GTestNewTest
nnoremap <silent> [t :<C-u>GTestPrev<CR>
nnoremap <silent> ]t :<C-u>GTestNext<CR>

""" vimspector debug
let g:vimspector_install_gadgets = [ 'vscode-cpptools' ]
let g:vimspector_enable_mappings='HUMAN'

""" Wiki
" <leader>wi - diary index
" <leader>w<leader>i - update diary index
" <leader>w<leader>w - diary today
  let g:vimwiki_autochdir = 1
  let g:vimwiki_hl_headers = 1
  let g:vimwiki_global_ext = 0
  let g:vimwiki_markdown_link_ext = 1
  let g:vimwiki_folding='expr'
  let g:vimwiki_list = [{ 'path': '~/Documents/wiki/',
    \ 'syntax': 'markdown',
    \ 'ext': '.md',
    \ 'nested_syntaxes': {'python': 'python', 'cpp': 'cpp', 'bash': 'sh' } }]

""" Custom Functions
source ~/.config/nvim/trim_whitespace.vim
source ~/.config/nvim/toggle_hex.vim

""" Ex Commands
cnoreabbrev MkDebug execute '!make -f bamboo.mk debug'
cnoreabbrev Build execute '!cmake --build build'
cnoreabbrev JsonFmt execute '%!jq .'
cnoreabbrev FmtPy execute '!black %'

cnoreabbrev RRun execute '!cargo run'
cnoreabbrev RBuild execute '!cargo build'
cnoreabbrev RFmt execute '!rustfmt %'

function! Mk(target)
  " call system('mk ' . shellescape(a:target))
  :execute '!make ' . a:target
endfunction
command! -nargs=1 Mk call Mk(<q-args>)

