-- https://neovim.io/doc/user/lsp.html
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      }
    }
  },
  root_markers = { ".git" },
})
