-- https://github.com/akinsho/bufferline.nvim
return {
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  lazy = false,
  keys = {
    { "<leader>1", function() require("bufferline").go_to(1, true) end, desc = "GoTo Ordinal Buffer 1" },
    { "<leader>2", function() require("bufferline").go_to(2, true) end, desc = "GoTo Ordinal Buffer 2" },
    { "<leader>3", function() require("bufferline").go_to(3, true) end, desc = "GoTo Ordinal Buffer 3" },
    { "<leader>4", function() require("bufferline").go_to(4, true) end, desc = "GoTo Ordinal Buffer 4" },
    { "<leader>5", function() require("bufferline").go_to(5, true) end, desc = "GoTo Ordinal Buffer 5" },
    { "<leader>6", function() require("bufferline").go_to(6, true) end, desc = "GoTo Ordinal Buffer 6" },
    { "<leader>7", function() require("bufferline").go_to(7, true) end, desc = "GoTo Ordinal Buffer 7" },
    { "<leader>8", function() require("bufferline").go_to(8, true) end, desc = "GoTo Ordinal Buffer 8" },
    { "<leader>9", function() require("bufferline").go_to(9, true) end, desc = "GoTo Ordinal Buffer 9" },
    { "<leader><", function() require("bufferline").move(-1) end, desc = "Move buffer to the left" },
    { "<leader>>", function() require("bufferline").move(1) end, desc = "Move buffer to the right" },
  },
  opts = {
    options = {
      -- numbers = "both",
      numbers = function(opts)
        return string.format("%s%s", opts.id, opts.raise(opts.ordinal))
      end,
      diagnostics = "nvim_lsp",
      separator_style = "slope",
    },
  },
}
