---@type vim.lsp.Config
return {
  cmd = { "emmylua_ls" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", "init.lua" },
  settings = {
    Lua = {
      format = {
        enable = true,
      },
      runtime = {
        version = "LuaJIT",
        requirePattern = {
          "lua/?.lua",
          "lua/?/init.lua",
          "?/lua/?.lua",
          "?/lua/?/init.lua",
        },
      },
      workspace = {
        library = {
          -- vim.api.nvim_get_runtime_file("", true),
          "$VIMRUNTIME",
          "$HOME/.dotfiles/home/.config/nvim/lua",
        },
      },
    },
  },
}
