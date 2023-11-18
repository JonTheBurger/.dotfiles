-- https://github.com/tpope/vim-surround
return {
  {
    "tpope/vim-surround",
    event = "BufEnter",
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end,
  }
}
