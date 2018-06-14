set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'tomasiser/vim-code-dark'    " Color scheme

Plugin 'tpope/vim-fugitive'             " Git integration
Plugin 'tpope/vim-surround'             " Parens, Quotes etc.
Plugin 'Valloric/YouCompleteMe'         " Autocomplete
Plugin 'scrooloose/syntastic'           " Live code warnings
Plugin 'airblade/vim-gitgutter'         " Git +/- in left gutter
Plugin 'ctrlpvim/ctrlp.vim'             " Fuzzy Search
Plugin 'easymotion/vim-easymotion'      " Jump through doc w/ letters
Plugin 'itchyny/lightline.vim'          " Pretty mode line
Plugin 'scrooloose/nerdtree'            " File tree
Plugin 'Xuyuanp/nerdtree-git-plugin'    " Git plugin

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

colorscheme codedark
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
