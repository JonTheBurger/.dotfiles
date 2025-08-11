return {
  {
    "zbirenbaum/copilot.lua",
    enabled = os.getenv("USER") ~= "vagrant",
    cmd = {
      "Copilot",
    },
    event = "InsertEnter",
    opts = {
      suggestion = {
        debounce = 350,
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    opts = {},
    keys = {
      { "<leader>C", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true, desc = "Code Companion" }},
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "codecompanion" },
    opts = {},
  },
}
