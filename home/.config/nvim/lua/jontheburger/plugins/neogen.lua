-- https://github.com/danymat/neogen?tab=readme-ov-file#features
return {
  "danymat/neogen",
  version = "*",
  keys = {
    { "<leader>com", function() require("neogen").generate() end, desc = "Generate docstring comment", },
  },
  cmd = {
    "Neogen",
  },
  dependencies = {
    "L3MON4D3/LuaSnip",
  },
  ---@type neogen.Configuration
  opts = {
    snippet_engine = "luasnip",
    insert_after_comment = true,
    binsert_after_comment = true,
    languages = {
      -- ["cpp.doxygen"] = require("neogen.configurations.cpp"),
      ["python"] = {
        template = {
          annotation_convention = "numpydoc",
        },
      },
    }
  },
  config = function(_, opts)
    local o = { noremap = true, silent = true }
    -- vim.api.nvim_set_keymap("i", "<C-e>", ":lua require('neogen').jump_next<CR>", o)
    require("neogen").setup(opts)
  end,
}
