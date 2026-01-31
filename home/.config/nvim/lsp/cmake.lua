return {
  cmd = { "/home/vagrant/.local/src/neocmakelsp/target/debug/neocmakelsp", "stdio" },
  -- cmd = { "neocmakelsp", "stdio" },
  filetypes = { "cmake", },
  root_markers = { "CMakePresets.json", },
  init_options = {
    use_snippets = false,
    semantic_token = false,
    format = {
      enable = false,
    },
    lint = {
      enable = true,
    },
  },
}
