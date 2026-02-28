local cmd = {
  "clangd",
  -- "--experimental-modules-support",
  -- "--query-driver=/usr/bin/arm-none-eabi-g++,/usr/bin/arm-none-eabi-gcc",
  "--query-driver=/usr/bin/**/g++*,/usr/bin/**/clang++*,/usr/bin/**/gcc*,/usr/bin/**/clang*",
  "--clang-tidy",
  "--header-insertion=iwyu",
  "--header-insertion-decorators",
  "--enable-config",
  "-j", "4",
  "--log=error",
  "--pretty",
}
if vim.fn.filereadable("compile_commands.json") then
  table.insert(cmd, "--compile-commands-dir=.")
end

return {
  cmd = cmd,
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", },
  root_markers = { ".clangd", "compile_commands.json", "CMakePresets.json" },
}
