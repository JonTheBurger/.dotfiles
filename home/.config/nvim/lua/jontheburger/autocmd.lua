-- Auto Commands
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"make"},
  command = "setlocal noexpandtab",
})
vim.api.nvim_create_autocmd({"BufWinEnter"}, {
  pattern = {"*"},
  callback = function()
    vim.cmd([[silent! :edit ++ff=unix]])
    vim.cmd([[silent! :%foldopen!]])
  end,
})
vim.api.nvim_create_autocmd({"BufWinEnter"}, {
  pattern = {
    "*.bin",
  },
  callback = function()
    vim.cmd([[:call ToggleHex()]])
  end,
})
vim.api.nvim_create_autocmd({"BufWinEnter"}, {
  pattern = {
    "*.a",
  },
  callback = function()
    vim.cmd([[:%! ar -t ]] .. vim.fn.expand('%:p'))
  end,
})
-- :%! xxd
