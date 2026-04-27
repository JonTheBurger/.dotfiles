---@type vim.lsp.Config
return {
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash", "zsh" },
  settings = {
    bashIde = {
      includeAllWorkspaceSymbols = true,
    },
  },
}
