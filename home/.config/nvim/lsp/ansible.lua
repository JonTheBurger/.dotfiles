---@type vim.lsp.Config
return {
  cmd = { "ansible-language-server", "--stdio" },
  filetypes = { "yaml.ansible" },
}
