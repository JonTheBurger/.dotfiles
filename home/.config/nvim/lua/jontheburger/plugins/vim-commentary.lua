-- https://github.com/tpope/vim-commentary
return {
  "tpope/vim-commentary",
  keys = {
    { "<C-_>", "gcc<ESC>", mode = {"n", "v"}, remap = true },
  },
}
