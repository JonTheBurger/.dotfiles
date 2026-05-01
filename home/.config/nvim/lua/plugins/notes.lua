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
      -- Disable by default
      enabled = false,
      overrides = {
        buftype = {
          -- Enable by default in non-file buffers
          nofile = {
            enabled = true,
            sign = { enabled = false },
            padding = { highlight = "NormalFloat" },
          },
        },
      },
    },
  },
}
