-- https://github.com/nvim-tree/nvim-tree.lua/blob/master/doc/nvim-tree-lua.txt
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- local icons = require("nvim-web-devicons")
local api = require("nvim-tree.api")

local function my_on_attach(bufnr)
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
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,           opts('Help'))
end

-- setup
-- map <leader>t :Lexplore<CR>
require("nvim-tree").setup({
  on_attach = my_on_attach,
  renderer = {
    highlight_opened_files = "all",
    icons = {
      glyphs = {
        default = "📄",
        symlink = "🔗",
        bookmark = "🔖",
        folder = {
          arrow_closed = "→",
          arrow_open = "↓",
          default = "📁",
          open = "📂",
          empty = "📁",
          empty_open = "📂",
          symlink = "⛓️",
          symlink_open = "🔗",
        },
        git = {
          unmerged = "Ͱ",
          deleted = "χ",
        },
      },
      -- webdev_colors = false,
    },
    special_files = {
      "CMakeLists.txt",
      "CMakePresets.json",
      "Cargo.toml",
      "Makefile",
      "README.md",
      "pyproject.toml",
    },
  },
  diagnostics = {
    icons = {
      hint = "H",
      info = "I",
      warning = "W",
      error = "E",
    }
  },
  view = {
    number = true,
    relativenumber = true,
  },
})

vim.keymap.set('n', '<Leader>t', api.tree.toggle)
