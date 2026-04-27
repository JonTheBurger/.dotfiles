-- https://neovim.io/doc/user/lsp.html
-- https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/configs
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
vim.lsp.config("*", {
  ---@diagnostic disable-next-line: assign-type-mismatch
  capabilities = {
    textDocument = {
      ---@diagnostic disable-next-line: missing-fields
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  },
  root_markers = { ".git" },
})
