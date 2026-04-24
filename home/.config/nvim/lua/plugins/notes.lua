---@type LazyPluginSpec[]
return {
  {
    -- https://github.com/MeanderingProgrammer/render-markdown.nvim
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "codecompanion", "markdown" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      enabled = false,
    },
  },
}
