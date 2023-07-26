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
  " Plug 'liuchengxu/space-vim-dark'
  Plug 'Mofiqul/vscode.nvim'

  " Convenience
  Plug 'easymotion/vim-easymotion'
  Plug 'junegunn/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'nvim-tree/nvim-tree.lua'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-surround'

  " Completions + LSP
  Plug 'neovim/nvim-lspconfig'
  Plug 'p00f/clangd_extensions.nvim'
  Plug 'hrsh7th/nvim-cmp'
  " Recommended by nvim-cmp
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  " Snippet Engine
  " Plug 'saadparwaiz1/cmp_luasnip'
  " Plug 'L3MON4D3/LuaSnip'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'

  " C++ (:VimspectorInstall vscode-cpptools)
  Plug 'puremourning/vimspector'
  " Plug 'ilyachur/cmake4vim'
  " Plug 'alepez/vim-gtest'

  " Plug 'chrisbra/Colorizer' " :ColorHighlight
  Plug 'vimwiki/vimwiki'

  " Auto-Install Plugins
  if _is_first_plug_install == 1
    execute 'PlugInstall'
  endif
call plug#end()

