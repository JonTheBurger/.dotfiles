-- Auto Commands
vim.api.nvim_create_user_command("Vh", "vertical help<CR>", {})
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
-- if vim.env.TERM == 'xterm-kitty' then
  -- vim.cmd([[autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]])
  -- vim.cmd([[autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]])
-- end
-- :%! xxd
