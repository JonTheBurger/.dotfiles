-- <space> as <leader>
vim.g.mapleader = " "
vim.g.modelines = 2
vim.opt.compatible = false
vim.opt.foldmethod = "syntax"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 0
vim.opt.spell = true
vim.opt.syntax = "on"
vim.opt.termguicolors = true
vim.opt.updatetime = 750
vim.opt.wrap = false

-- Searching
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Host System Integration
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamed,unnamedplus"

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Document Spacing
vim.opt.colorcolumn = "80,88,120"
vim.opt.shiftwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.smarttab = true
vim.opt.tabstop = 3
vim.opt.textwidth = 0
vim.opt.expandtab = true
vim.opt.fixeol = true
vim.opt.list = true
vim.opt.listchars = { space = '·', }

-- Undo File
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undodir = vim.fn.expand(vim.fn.stdpath("state") .. "/undo")
vim.opt.undofile = true
