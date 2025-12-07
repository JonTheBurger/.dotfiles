return {
  cmd = {
    "clangd",
    "--query-driver=/usr/bin/**/g++*,/usr/bin/**/clang++*,/usr/bin/**/gcc*,/usr/bin/**/clang*",
    "--experimental-modules-support",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--header-insertion-decorators",
    "--enable-config",
    "-j", "4",
    "--log=info",
    "--pretty",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", },
  root_markers = { ".clangd", "compile_commands.json", "CMakePresets.json" },
}
