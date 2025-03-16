return {
  cmd = { "slint-lsp", "--backend", "software" },
  filetypes = { "slint" },
  root_markers = { ".git" },
  single_file_support = true,
  settings = {
    slint = {
      preview = true,
    },
  },
}
