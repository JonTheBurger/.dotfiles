-- <space> as <leader>
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
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
vim.opt.list = true
vim.opt.smarttab = true
vim.opt.tabstop = 3
vim.opt.textwidth = 0
vim.opt.listchars = { space = "·", tab = "»»", nbsp = "␣" }
vim.opt.fillchars:append({
  diff = "╱",
  stl = "─",
  stlnc = "─",
})
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "⚑",
      [vim.diagnostic.severity.INFO] = "",
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
    },
  },
  virtual_lines = false,
  virtual_text = true,
})
vim.diagnostic.config({
  float = {
    border = "rounded",
  },
})
local hover = vim.lsp.buf.hover
vim.lsp.buf.hover = function()
  return hover({
    wrap = false,
    max_width = 100,
    max_height = 40,
    border = "rounded",
  })
end


-- Undo File
vim.opt.backup = false
vim.opt.backupdir:prepend(vim.fn.stdpath("state") .. "/backup//")
vim.opt.swapfile = false
vim.opt.directory:prepend(vim.fn.stdpath("state") .. "/swap//")
vim.opt.undodir = vim.fn.expand(vim.fn.stdpath("state") .. "/undo")
vim.opt.undofile = true

-- Gui
-- vim.opt.guifont = "FiraCode Nerd Font Mono:h12"
vim.o.winborder = "double"
if vim.g.neovide then
  vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
end
