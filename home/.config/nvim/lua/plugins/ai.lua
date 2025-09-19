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
        debounce = 3500,
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        cmake = false,
        ["."] = false,
      },
    },
  },
  {
    "fang2hou/blink-copilot",
    opts = {
      max_completions = 2,
      max_attempts = 4,
      debounce = 3500,
      auto_refresh = {
        backward = true,
        forward = true,
      },
    }
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
