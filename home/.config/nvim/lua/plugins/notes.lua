return {
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
