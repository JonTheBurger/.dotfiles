vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.highlight.on_yank()
  end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Support Makefile Tabs",
  pattern = { "make" },
  command = "setlocal noexpandtab",
})
vim.api.nvim_create_autocmd({ "WinNew", "WinLeave", "BufWinEnter" }, {
  desc = "Keep Widgets out of BufferLine",
  pattern = { "*DAP*", "*dap*", "Neotest *" },
  callback = function(args)
    vim.api.nvim_buf_set_option(args.buf, "buflisted", false)
  end,
})
vim.api.nvim_create_autocmd({ "BufEnter", }, {
  desc = "Keep unnamed buffers out of BufferLine",
  pattern = { "*", },
  callback = function(args)
    if args.file == "" then
      vim.api.nvim_buf_set_option(args.buf, "buflisted", false)
    end
  end,
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  desc = "Dump hex",
  pattern = { "*.bin", },
  callback = function()
    require("config.util").toggle_hex()
  end,
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  desc = "Dump archives",
  pattern = { "*.a", },
  callback = function()
    vim.cmd([[:%! ar -t ]] .. vim.fn.expand('%:p'))
  end,
})
-- TODO if possession keeps breaking on folds
-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   pattern = { "*" },
--   command = "normal zx",
-- })
