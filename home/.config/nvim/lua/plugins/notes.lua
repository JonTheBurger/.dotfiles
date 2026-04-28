---@module "lazy"
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
      overrides = {
        -- Enable by default for markdown hover content
        buftype = {
          nofile = {
            render_modes = true,
            sign = { enabled = false },
          },
        },
      },
      file_types = {
        -- Don't enable by default for actual markdown files
        markdown = {
          render_modes = false,
        },
      },
    },
  },
}
