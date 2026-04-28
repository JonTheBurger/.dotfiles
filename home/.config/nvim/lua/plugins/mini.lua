---@module "lazy"
---@type LazyPluginSpec[]
return {
  {
    -- https://github.com/nvim-mini/mini.nvim
    "nvim-mini/mini.nvim",
    lazy = false,
    keys = {
      { "<C-_>", "gcc<ESC>", mode = { "n", "v" }, remap = true, desc = "Comment" },
      { "<C-/>", "gcc<ESC>", mode = { "n", "v" }, remap = true, desc = "Comment" },
    },
    opts = {
      ai = {
        n_lines = 50,
        search_method = "cover_or_next",
        silent = false,
      },
      align = {
        mappings = {
          start = "ga",
          start_with_preview = "gA",
        },
      },
      move = {
        mappings = {
          -- Move visual selection in Visual mode
          left = "<S-M-h>",
          right = "<S-M-l>",
          down = "<S-M-j>",
          up = "<S-M-k>",
          -- Move current line in Normal mode
          line_left = "<S-M-h>",
          line_right = "<S-M-l>",
          line_down = "<S-M-j>",
          line_up = "<S-M-k>",
        },
      },
      operators = {
        evaluate = { prefix = nil },
        exchange = { prefix = "gx" },
        multiply = { prefix = "gm" },
        replace = { prefix = nil },
        sort = { prefix = "go" },
      },
      splitjoin = {
        mappings = {
          toggle = "gJ",
        },
      },
    },
    config = function(_, opts)
      require("mini.ai").setup(opts.ai)
      require("mini.align").setup(opts.align)
      require("mini.comment").setup(opts.comment)
      require("mini.cursorword").setup()
      require("mini.move").setup(opts.move)
      require("mini.operators").setup(opts.operators)
      require("mini.splitjoin").setup(opts.splitjoin)
    end,
  },
}
