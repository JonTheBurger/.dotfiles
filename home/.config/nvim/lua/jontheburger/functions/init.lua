local fundir = vim.fn.expand(vim.fn.stdpath("config") .. "/lua/jontheburger/functions/")
vim.cmd("source " .. fundir .. "toggle_hex.vim")
vim.cmd("source " .. fundir .. "delete_hidden_buffers.vim")
return {
  reload = require("jontheburger.functions.reload"),
}
