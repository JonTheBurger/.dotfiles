-- https://github.com/simrat39/symbols-outline.nvim
return {
  "simrat39/symbols-outline.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("symbols-outline").setup()
    -- This plugin can't handle keys
    vim.keymap.set('n', '<leader>y', '<CMD>SymbolsOutline<CR>')
  end,
  -- keys = {
  --   "<leader>y",
  --   function()
  --     require("symbols-outline").toggle_outline()
  --   end,
  --   mode = "n",
  --   desc="Toggle Symbol Outline",
  -- },
}
