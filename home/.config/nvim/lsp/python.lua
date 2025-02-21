return {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python", },
  root_markers = { "pyproject.toml", ".git", "main.py" },
  settings = {
    python = {
      disableOrganizeImports = true,
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true
      }
    }
  }
}
