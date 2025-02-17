-- https://github.com/nvim-tree/nvim-tree.lua
local function on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
  vim.keymap.set("n", "Z", api.tree.expand_all, opts("Expand All"))
  vim.keymap.set("n", "E", "", { buffer = bufnr })
  vim.keymap.del("n", "E", { buffer = bufnr })
  vim.keymap.set("n", "e", "", { buffer = bufnr })
  vim.keymap.del("n", "e", { buffer = bufnr })
end

return {{
  "nvim-tree/nvim-tree.lua",
  version = "*",
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
  },
  config = function()
    local icons = require("nvim-web-devicons")
    require("nvim-tree").setup({
      on_attach = on_attach,
      update_focused_file = {
        enable = true,
      },
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
    -- Keep NvimTree out of BufferLine
    vim.api.nvim_create_autocmd({"BufWinEnter"}, {
      pattern = {
        "NvimTree*",
      },
      callback = function()
        vim.cmd("setl nobuflisted")
      end,
    })
  end,
},{ 'echasnovski/mini.nvim', version = '*' },
}
