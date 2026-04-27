---@type vim.lsp.Config
return {
  cmd = { "slint-lsp", "--backend", "software" },
  filetypes = { "slint" },
  single_file_support = true,
  settings = {
    slint = {
      preview = true,
    },
  },
}
