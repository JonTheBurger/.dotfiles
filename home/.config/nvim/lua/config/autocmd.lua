---@module "Commands that automatically run under some condition"
-- https://neovim.io/doc/user/autocmd/#autocmd-events
vim.api.nvim_create_augroup("JVim", { clear = true })

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  desc = "Highlight when yanking (copying) text",
  group = "JVim",
  callback = function() vim.highlight.on_yank({ higroup = "CurSearch" }) end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "FileType" }, {
  desc = "Enable TreeSitter Highlights",
  group = "JVim",
  pattern = require("config.prefs").ts_languages,
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Makefile <Tab> character",
  group = "JVim",
  pattern = { "make" },
  command = "setlocal noexpandtab",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "gd support for vim help",
  group = "JVim",
  pattern = { "help" },
  callback = function() vim.keymap.set("n", "gd", "<C-]>", { buffer = true, desc = "Go to help tag" }) end,
})

vim.api.nvim_create_autocmd({ "FileType", "TermOpen" }, {
  desc = "gd & ]d support for terminal output",
  group = "JVim",
  pattern = { "*[Oo]utput*", "*/bin/*sh" },
  callback = function(ev)
    local buffn = require("config.fn").buf
    -- stylua: ignore start
    vim.keymap.set("n", "gf", function() buffn.gf() end, { buffer = ev.buf, silent = true, desc = "Go to file, pick window" })
    vim.keymap.set("n", "]d", function() buffn.jump_to_diagnostic("next") end, { buffer = ev.buf, silent = true, desc = "Jump to prev diagnostic" })
    vim.keymap.set("n", "[d", function() buffn.jump_to_diagnostic("prev") end, { buffer = ev.buf, silent = true, desc = "Jump to next diagnostic" })
    vim.keymap.set("n", "]e", function() buffn.jump_to_diagnostic("next", "error") end, { buffer = ev.buf, silent = true, desc = "Jump to prev error" })
    vim.keymap.set("n", "[e", function() buffn.jump_to_diagnostic("prev", "error") end, { buffer = ev.buf, silent = true, desc = "Jump to prev error" })
    -- stylua: ignore end
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  desc = "Dump archives",
  group = "JVim",
  pattern = { "*.a" },
  callback = function() vim.cmd([[:%! ar -t ]] .. vim.fn.expand("%:p")) end,
})
