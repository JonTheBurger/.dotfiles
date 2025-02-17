return {
  {
    -- https://github.com/MeanderingProgrammer/render-markdown.nvim
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {
      latex = {
        enabled = false,
      },
    },
    ft = { "markdown" },
  },
  {
    -- https://github.com/iamcco/markdown-preview.nvim
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    keys = {
      { "<leader>MP", "<cmd>MarkdownPreview<CR>",       desc = "MarkdownPreview" },
      { "<leader>MS", "<cmd>MarkdownPreviewStop<CR>",   desc = "MarkdownPreviewStop" },
      { "<leader>MT", "<cmd>MarkdownPreviewToggle<CR>", desc = "MarkdownPreviewToggle" },
    },
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
}
