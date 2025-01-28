-- Auto Commands
vim.api.nvim_create_user_command("Vh", "vertical help<CR>", {})
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "make" },
  command = "setlocal noexpandtab",
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd([[silent! :edit ++ff=unix]])
    vim.cmd([[silent! :%foldopen!]])
  end,
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = {
    "*.bin",
  },
  callback = function()
    vim.cmd([[:call ToggleHex()]])
  end,
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = {
    "*.a",
  },
  callback = function()
    vim.cmd([[:%! ar -t ]] .. vim.fn.expand('%:p'))
  end,
})
-- Open help window in a vertical split to the right.
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("help_window_right", {}),
  pattern = { "*.txt" },
  callback = function()
    if vim.o.filetype == 'help' then vim.cmd.wincmd("L") end
  end
})
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
vim.api.nvim_create_autocmd("VimLeave", {
  desc = "Fix horrible auto-session default to give up on error",
  callback = function()
    require("auto-session").SaveSession()
  end,
})
-- if vim.env.TERM == 'xterm-kitty' then
-- vim.cmd([[autocmd UIEnter * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[>1u") | endif]])
-- vim.cmd([[autocmd UILeave * if v:event.chan ==# 0 | call chansend(v:stderr, "\x1b[<1u") | endif]])
-- end
-- :%! xxd
