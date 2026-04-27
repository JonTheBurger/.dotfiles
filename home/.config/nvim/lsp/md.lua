---@type vim.lsp.Config
return {
  cmd = { "marksman", "server" },
  filetypes = { "markdown" },
  root_markers = { ".marksman.toml", "README.md", "index.md" },
}
