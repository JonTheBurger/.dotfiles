local cfamily = require("config.fn").fs.find_vscode_binary("sonarsource.sonarlint_ondemand-analyzers", "sonarcfamily.jar")

---@type vim.lsp.Config
return {
  cmd = {
    "sonarlint-ls",
    "-stdio",
    "-analyzers",
    cfamily,
  },
  filetypes = { "c", "cpp", "cs", "python" },
  single_file_support = true,
  settings = {
    sonarlint = {
      pathToCompileCommands = "compile_commands.json",
    },
  },
}
