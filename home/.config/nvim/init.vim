""" Recycle Common Settings
source ~/.vimrc
set list
set lcs+=space:·
autocmd filetype make setlocal noexpandtab

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
map <leader>x :call ToggleHex()<CR>

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
  " NERDTree
  Plug 'preservim/nerdtree'
  " EasyMotion
  Plug 'easymotion/vim-easymotion'
  " Fuzzy Finder
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  " Completion + LSP | :CocInstall coc-clangd | :CocInstall coc-cmake | :CocInstall coc-python | :CocInstall coc-rls
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " C++ Semantic Highlighting
  Plug 'jackguo380/vim-lsp-cxx-highlight'
  " vim-dispatch (CMake status in background)
  Plug 'tpope/vim-dispatch'
  " CMake
  Plug 'ilyachur/cmake4vim'
  " Google Test
  Plug 'alepez/vim-gtest'
  " Debug (:VimspectorInstall vscode-cpptools)
  Plug 'puremourning/vimspector'
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
:map <C-P> :FZF<CR>

""" NERDTree
nnoremap <leader>t :NERDTreeFocus<CR>
:command Pwd NERDTree %:p:h

""" Coc Begin
  " TextEdit might fail if hidden is not set.
  set hidden

  " Some servers have issues with backup files, see #649.
  set nobackup
  set nowritebackup

  " Give more space for displaying messages.
  set cmdheight=2

  " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
  " delays and poor user experience.
  set updatetime=300

  " Don't pass messages to |ins-completion-menu|.
  set shortmess+=c

  " Always show the signcolumn, otherwise it would shift the text each time
  " diagnostics appear/become resolved.
  if has("patch-8.1.1564")
    " Recently vim can merge signcolumn and number column into one
    set signcolumn=number
  else
    set signcolumn=yes
  endif

  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  " Make <CR> auto-select the first completion item and notify coc.nvim to
  " format on enter, <cr> could be remapped by other vim plugin
  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " Use `[g` and `]g` to navigate diagnostics
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window.
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Symbol renaming.
  nmap <leader>rn <Plug>(coc-rename)

  " Formatting selected code.
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Applying codeAction to the selected region.
  " Example: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap keys for applying codeAction to the current buffer.
  nmap <leader>ac  <Plug>(coc-codeaction)
  " Apply AutoFix to problem on the current line.
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Map function and class text objects
  " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)
  xmap ic <Plug>(coc-classobj-i)
  omap ic <Plug>(coc-classobj-i)
  xmap ac <Plug>(coc-classobj-a)
  omap ac <Plug>(coc-classobj-a)

  " Remap <C-f> and <C-b> for scroll float windows/popups.
  if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  endif

  " Use CTRL-S for selections ranges.
  " Requires 'textDocument/selectionRange' support of language server.
  nmap <silent> <C-s> <Plug>(coc-range-select)
  xmap <silent> <C-s> <Plug>(coc-range-select)

  " Add `:Format` command to format current buffer.
  command! -nargs=0 Format :call CocAction('format')

  " Add `:Fold` command to fold current buffer.
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " Add `:OR` command for organize imports of the current buffer.
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " Add (Neo)Vim's native statusline support.
  " NOTE: Please see `:h coc-status` for integrations with external plugins that
  " provide custom statusline: lightline.vim, vim-airline.
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  " Mappings for CoCList
  " Show all diagnostics.
  nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions.
  nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
  " Show commands.
  nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document.
  nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols.
  nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list.
  nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
""" Coc End

"nnoremap <leader>lm :call LanguageClient_contextMenu()<CR>
  "nnoremap <leader>lh :call LanguageClient#textDocument_hover()<CR>
  "nnoremap <F2> :call LanguageClient#textDocument_definition()<CR>
  ":command Dfn :call LanguageClient#textDocument_definition()<CR>
  ":command Rename :call LanguageClient#textDocument_rename()
  ":command Fmt :call LanguageClient#textDocument_formatting()<CR>
  ":command Usages :call LanguageClient#textDocument_references()<CR>
  ":command Doc :call LanguageClient_textDocument_documentSymbol()<CR>

""" clangd
cnoreabbrev A CocCommand clangd.switchSourceHeader

""" cmake4vim
cnoreabbrev Target CMakeSelectTarget
cnoreabbrev Tgt FZFCMakeSelectTarget
let g:cmake_build_type = 'Debug'
let g:cmake_compile_commands = 1
let g:cmake_compile_commands_link = './'
let g:cmake_project_generator = 'Ninja'

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

