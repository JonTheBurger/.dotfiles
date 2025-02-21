return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", },
  settings = {
    yaml = {
      schemaStore = {
        enable = true,
      },
      schemas = {
        ["https://json.schemastore.org/clang-format.json"] = ".clang-format",
        ["https://json.schemastore.org/mkdocs-1.6.json"] = "mkdocs.yml",
      },
    },
  },
}
