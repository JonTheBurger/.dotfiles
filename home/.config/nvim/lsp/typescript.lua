---@type vim.lsp.Config
return {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript" },
  single_file_support = true,
  settings = {},
}
