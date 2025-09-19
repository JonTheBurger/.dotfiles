local cfamily = require("config.fn").fs.find_vscode_binary("sonarsource.sonarlint_ondemand-analyzers", "sonarcfamily.jar")

return {
  cmd = {
    "sonarlint-ls",
    "-stdio",
    "-analyzers",
    cfamily,
  },
  filetypes = { "c", "cpp", "cs", "python" },
  root_markers = { ".git" },
  single_file_support = true,
  settings = {
    sonarlint = {
      pathToCompileCommands = "build/compile_commands.json",
    },
  },
}
