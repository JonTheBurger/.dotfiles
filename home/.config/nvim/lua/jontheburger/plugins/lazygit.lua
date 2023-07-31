-- https://github.com/kdheepak/lazygit.nvim
return {
  "kdheepak/lazygit.nvim",
  keys = {
    { "<leader>gg", "<CMD>LazyGit<CR>", desc = "Git Lazy Toggle" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
