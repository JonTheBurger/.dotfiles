-- https://github.com/tpope/vim-commentary
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"sh"},
  command = [[setlocal commentstring=#\ %s]],
})
-- return {
--   "tpope/vim-commentary",
--   keys = {
--     { "<C-_>", "gcc<ESC>", mode = {"n", "v"}, remap = true },
--   },
-- }

-- add this to your lua/plugins.lua, lua/plugins/init.lua,  or the file you keep your other plugins:
return {
  "numToStr/Comment.nvim",
  opts = {},
  keys = {
    { "<C-_>", "gcc<ESC>", mode = {"n", "v"}, remap = true },
  },
  lazy = false,
}
