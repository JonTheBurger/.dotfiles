return {
  "echasnovski/mini.nvim",
  enabled = true,
  version = "*",
  lazy = false,
  keys = {
    { "<C-_>", "gcc<ESC>", mode = { "n", "v" }, remap = true, desc = "Toggle Comment" },
    { "<C-/>", "gcc<ESC>", mode = { "n", "v" }, remap = true, desc = "Toggle Comment" },
  },
  opts = {
    --- @type MiniAi.config
    ai = {
      mappings = {
        goto_right = "g]",
        goto_left = "g[",
      },
      n_lines = 50,
      search_method = "cover_or_next",
      silent = false,
    },
    --- @type MiniAlign.config
    align = {
      mappings = {
        start = "ga",
        start_with_preview = "gA",
      },
    },
    --- @type MiniMove.config
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
  },
  config = function(_, opts)
    -- opts.align.steps = {
    --   pre_justify = { require("mini.align").gen_step.filter("n == 1") }
    -- }
    require("mini.ai").setup(opts.ai)
    require("mini.align").setup(opts.align)
    require("mini.bracketed").setup(opts.bracketed)
    require("mini.comment").setup(opts.comment)
    require("mini.cursorword").setup(opts.comment)
    require("mini.move").setup(opts.move)
    if not vim.g.vscode then
      require("mini.indentscope").setup(opts.indentscope)
    end
  end,
}
