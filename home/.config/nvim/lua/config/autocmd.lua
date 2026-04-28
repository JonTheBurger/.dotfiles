---@module "Commands that automatically run under some condition"
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  desc = "Highlight when yanking (copying) text",
  callback = function() vim.highlight.on_yank({ higroup = "CurSearch" }) end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "FileType" }, {
  desc = "Enable TreeSitter Highlights",
  pattern = require("config.prefs").ts_languages,
  callback = function()
    vim.treesitter.start()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Makefile <Tab> character",
  pattern = { "make" },
  command = "setlocal noexpandtab",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "gd support for vim help",
  pattern = { "help" },
  callback = function() vim.keymap.set("n", "gd", "<C-]>", { buffer = true, desc = "Go to help tag" }) end,
})

vim.api.nvim_create_autocmd({ "FileType", "TermOpen" }, {
  desc = "gd & ]d support for terminal output",
  pattern = { "*[Oo]utput*", "*/bin/*sh" },
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }
    vim.keymap.set("n", "gf", function() require("config.fn").buf.gf() end, opts)
    vim.keymap.set("n", "]d", function() require("config.fn").buf.jump_to_diagnostic("next") end, opts)
    vim.keymap.set("n", "[d", function() require("config.fn").buf.jump_to_diagnostic("prev") end, opts)
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  desc = "Dump archives",
  pattern = { "*.a" },
  callback = function() vim.cmd([[:%! ar -t ]] .. vim.fn.expand("%:p")) end,
})
