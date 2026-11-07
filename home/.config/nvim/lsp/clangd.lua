local cmd = {
  "clangd",
  -- "--experimental-modules-support",
  "--query-driver=**",
  "--clang-tidy",
  "--header-insertion=iwyu",
  "--header-insertion-decorators",
  "--enable-config",
  "-j",
  "4",
  "--log=error",
  "--pretty",
}

if vim.fn.filereadable("compile_commands.json") == 1 then
  table.insert(cmd, "--compile-commands-dir=.")

  if require("config.fn").fs.file_contains("compile_commands.json", "arm-none-eabi") then table.insert(cmd, "--query-driver=/usr/bin/arm-none-eabi-*") end
end

---@type vim.lsp.Config
return {
  cmd = cmd,
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = { ".clangd", "compile_commands.json", "CMakePresets.json" },
}
