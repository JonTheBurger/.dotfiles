-- https://github.com/tpope/vim-fugitive
return {
  "tpope/vim-fugitive",
  cmd = {
    "Git blame",
  },
  keys = {
    { "<leader>gb", "<CMD>Git blame<CR>", desc = "Git Blame Toggle" },
  },
}
