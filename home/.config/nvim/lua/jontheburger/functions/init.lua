local M = {}
M.qaev = require("jontheburger.functions.qaev").buffer_quit_all_except_visible

vim.api.nvim_create_user_command("QAEV", M.qaev, {})

local fundir = vim.fn.expand(vim.fn.stdpath("config") .. "/lua/jontheburger/functions/")
vim.cmd("source " .. fundir .. "toggle_hex.vim")
vim.cmd("source " .. fundir .. "delete_hidden_buffers.vim")

return M
