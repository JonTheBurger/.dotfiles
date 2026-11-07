---@type vim.lsp.Config
return {
  cmd = { "starpls" },
  filetypes = { "bzl", "starlark" },
  root_markers = { "WORKSPACE", "WORKSPACE.bazel", "MODULE.baze", ".buckconfig" },
}

