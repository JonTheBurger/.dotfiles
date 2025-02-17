return {
  cmd = { "yaml-language-server", },
  filetypes = { "yaml", },
  settings = {
    yaml = {
      schemaStore = {
        enable = true,
      },
      schemas = {
        ["https://json.schemastore.org/mkdocs-1.6.json"] = "mkdocs.yml",
      },
    },
  },
}
