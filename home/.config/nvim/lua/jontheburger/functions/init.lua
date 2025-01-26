local fundir = vim.fn.expand(vim.fn.stdpath("config") .. "/lua/jontheburger/functions/")
vim.cmd("source " .. fundir .. "toggle_hex.vim")
vim.cmd("source " .. fundir .. "delete_hidden_buffers.vim")
vim.api.nvim_create_user_command(
  "E",
  function(opt)
    vim.cmd("e %:p:h/" .. opt.args)
  end,
  { desc = "Edit file in current buffer's containing directory", nargs = 1 })
return {
  reload = require("jontheburger.functions.reload"),
}
