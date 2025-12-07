return {
  name = "dts-lsp",
  cmd = {"dts-lsp"},
  root_dir = vim.fs.dirname(vim.fs.find({'.git'}, { upward = true })[1]),
}
