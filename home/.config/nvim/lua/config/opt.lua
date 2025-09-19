-- <space> as <leader>
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.modelines = 2
vim.opt.compatible = false
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 0
vim.opt.spell = true
vim.opt.spelllang = "en_us"
vim.opt.syntax = "on"
vim.opt.termguicolors = true
vim.opt.timeout = false
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.wrap = false

-- Searching
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmode = false
vim.opt.wildmode = { "longest:full", "full" }

-- Host System Integration
if vim.fn.executable("zsh") == 1 then
  vim.opt.shell = "/usr/bin/zsh"
end
vim.opt.mouse = "a"
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Document Spacing
vim.opt.colorcolumn = "80,88,120"
vim.opt.shiftwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.expandtab = true
vim.opt.fixeol = true
vim.opt.breakindent = true
vim.opt.indentexpr = ""
vim.opt.list = true
vim.opt.smarttab = true
vim.opt.tabstop = 3
vim.opt.textwidth = 0
vim.opt.listchars = { space = "·", tab = "»»", nbsp = "␣" }
vim.opt.fillchars:append({ diff = "╱" })

-- Undo File
vim.opt.backup = false
vim.opt.backupdir:prepend(vim.fn.stdpath("state") .. "/backup//")
vim.opt.swapfile = false
vim.opt.directory:prepend(vim.fn.stdpath("state") .. "/swap//")
vim.opt.undodir = vim.fn.expand(vim.fn.stdpath("state") .. "/undo")
vim.opt.undofile = true

-- Gui
-- vim.opt.guifont = "FiraCode Nerd Font Mono:h12"
if vim.g.neovide then
  vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
end
