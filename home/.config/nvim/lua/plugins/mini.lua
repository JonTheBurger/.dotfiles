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
          left = "<S-A-h>",
          right = "<S-A-l>",
          down = "<S-A-j>",
          up = "<S-A-k>",
          -- Move current line in Normal mode
          line_left = "<S-A-h>",
          line_right = "<S-A-l>",
          line_down = "<S-A-j>",
          line_up = "<S-A-k>",
        },
      },
      operators = {
        evaluate = { prefix = "" },
        exchange = { prefix = "gx" },
        multiply = { prefix = "gm" },
        replace = { prefix = "" },
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
      require("mini.cursorword").setup(opts.cursorword)
      require("mini.move").setup(opts.move)
      require("mini.operators").setup(opts.operators)
      require("mini.splitjoin").setup(opts.splitjoin)
    end,
  },
}
