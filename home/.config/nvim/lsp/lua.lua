return {
  cmd = { "lua-language-server", },
  filetypes = { "lua", },
  root_markers = { ".luarc.json", ".luarc.jsonc", "init.lua", },
  settings = {
    Lua = {
      format = {
        enable = false,
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
}
