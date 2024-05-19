return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  keys = {
    { "<leader>MP", "<CMD>MarkdownPreview<CR>", desc = "MarkdownPreview" },
    { "<leader>MS", "<CMD>MarkdownPreviewStop<CR>", desc = "MarkdownPreviewStop" },
    { "<leader>MT", "<CMD>MarkdownPreviewToggle<CR>", desc = "MarkdownPreviewToggle" },
  },
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
}
