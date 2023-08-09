-- https://github.com/tpope/vim-commentary
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"sh"},
  command = [[setlocal commentstring=#\ %s]],
})
return {
  "tpope/vim-commentary",
  keys = {
    { "<C-_>", "gcc<ESC>", mode = {"n", "v"}, remap = true },
  },
}
