-- <space> as <leader>
vim.g.mapleader = " "
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

if vim.fn.has("wsl") == 1 then
  -- sudo ln -s /mnt/c/Program\ Files/Neovim/bin/win32yank.exe /usr/local/bin/win32yank
  local win32yank = "win32yank"
  local clip_exe = "/mnt/c/Windows/System32/clip.exe"
  local powershell = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"

  if vim.fn.executable(win32yank) then
    vim.g.clipboard = {
      name = "win32yank-wsl",
      copy = {
        ["+"] = win32yank .. " -i --crlf",
        ["*"] = win32yank .. " -i --crlf",
      },
      paste = {
        ["+"] = win32yank .. " -o --lf",
        ["*"] = win32yank .. " -o --lf",
      },
      cache_enabled = false,
    }
  elseif vim.fn.executable(clip_exe) and vim.fn.executable(powershell) then
    vim.g.clipboard = {
      name = "clip-windows",
      copy = {
        ['+'] = clip_exe,
        ['*'] = clip_exe,
      },
      paste = {
        ['+'] = powershell .. " -noprofile -command Get-Clipboard",
        ['*'] = powershell .. " -noprofile -command Get-Clipboard",
      },
      cache_enabled = false,
    }
  end
end

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Document Spacing
vim.opt.colorcolumn = "80,88,120"
vim.opt.shiftwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.expandtab = true
vim.opt.fixeol = true
vim.opt.indentexpr = ""
vim.opt.list = true
vim.opt.smarttab = true
vim.opt.tabstop = 3
vim.opt.textwidth = 0
vim.opt.listchars = { space = '·', tab = "»»" }

-- Undo File
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undodir = vim.fn.expand(vim.fn.stdpath("state") .. "/undo")
vim.opt.undofile = true

-- Gui
vim.opt.guifont = "FiraCode Nerd Font Mono:h12"
