local fundir = vim.fn.expand(vim.fn.stdpath("config") .. "/lua/jontheburger/functions/")
vim.cmd("source " .. fundir .. "toggle_hex.vim")
return {
  reload = require("jontheburger.functions.reload"),
}
