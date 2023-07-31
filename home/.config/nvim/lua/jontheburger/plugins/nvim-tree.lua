-- https://github.com/nvim-tree/nvim-tree.lua
local function on_attach()
  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true
    }
  end

  -- default mappings
  local api = require("nvim-tree.api")
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,           opts('Help'))
end

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  on_attach = on_attach,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>e",
      function()
        local api = require("nvim-tree.api")
        api.tree.toggle()
      end,
      desc = "File Tree Toggle",
    },
    {
      "<leader>t",
      function()
        local api = require("nvim-tree.api")
        api.tree.toggle()
      end,
      desc = "File Tree Toggle",
    },
  },
  config = function()
    local icons = require("nvim-web-devicons")
    require("nvim-tree").setup({
      renderer = {
        highlight_opened_files = "icon",
        icons = {
          webdev_colors = true,
          git_placement = "signcolumn",
        },
        special_files = {
          -- "CMakeLists.txt",
          -- "CMakePresets.json",
          -- "Cargo.toml",
          -- "Makefile",
          -- "README.md",
          -- "pyproject.toml",
        },
      },
      filters = {
        git_ignored = false,
      },
      view = {
        number = true,
        relativenumber = true,
      },
    })
  end,
}
