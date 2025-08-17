local lls = {
  cmd = { "lua-language-server", },
  filetypes = { "lua", },
  root_markers = { ".luarc.json", ".luarc.jsonc", "init.lua", },
  settings = {
    Lua = {
      format = {
        enable = false,
      },
      runtime = {
        version = "LuaJIT",
        requirePattern = {
          "lua/?.lua",
          "lua/?/init.lua",
          "?/lua/?.lua",
          "?/lua/?/init.lua"
        }
      },
      workspace = {
        library = {
          vim.api.nvim_get_runtime_file("", true),
          "$VIMRUNTIME"
        }
      },
    },
  },
}

local emmy = {
  cmd = { "emmylua_ls", },
  filetypes = lls.filetypes,
  root_markers = lls.root_markers,
  settings = lls.settings,
}

return lls
