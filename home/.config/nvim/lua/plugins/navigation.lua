return {
  {
    -- https://github.com/mrjones2014/smart-splits.nvim
    "mrjones2014/smart-splits.nvim",
    keys = {
      { "<C-h>", function() require("smart-splits").move_cursor_left() end,  desc = "Move left one pane" },
      { "<C-j>", function() require("smart-splits").move_cursor_down() end,  desc = "Move down one pane" },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end,    desc = "Move up one pane" },
      { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move right one pane" },
    },
  },
  {
    -- https://github.com/chrisgrieser/nvim-various-textobjs
    "chrisgrieser/nvim-various-textobjs",
    keys = {
      { "i$", "<cmd>lua require('various-textobjs').lineCharacterwise('inner')<CR>", mode = { "o", "x" } },
      { "a$", "<cmd>lua require('various-textobjs').lineCharacterwise('outer')<CR>", mode = { "o", "x" } },
      { "gG", "<cmd>lua require('various-textobjs').entireBuffer()<CR>",             mode = { "o", "x" } },
      { "as", '<cmd>lua require("various-textobjs").subword("outer")<CR>',           mode = { "o", "x" } },
      { "is", "<cmd>lua require('various-textobjs').subword('inner')<CR>",           mode = { "o", "x" } },
      { "ik", "<cmd>lua require('various-textobjs').key('inner')<CR>",               mode = { "o", "x" } },
      { "ak", "<cmd>lua require('various-textobjs').key('outer')<CR>",               mode = { "o", "x" } },
      { "iv", "<cmd>lua require('various-textobjs').value('inner')<CR>",             mode = { "o", "x" } },
      { "av", "<cmd>lua require('various-textobjs').value('outer')<CR>",             mode = { "o", "x" } },
    },
  },
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", },
    },
    cmd = { "TSUpdateSync" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>",      desc = "Decrement selection", mode = "x" },
    },
    ---@type TSConfig
    opts = {
      auto_install = true,
      sync_install = false,
      ignore_install = {},
      modules = {},
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "comment",
        "cpp",
        "doxygen",
        "json",
        "lua",
        "markdown",
        "python",
        "rust",
        "yaml",
      },
      highlight = {
        enable = true,
        disable = {},
      },
      indent = { enable = true },
      incremental_selection = { enable = true },
      textobjects = {
        swap = {
          enable = true,
          swap_next = { ["<leader>a"] = "@parameter.inner", },
          swap_previous = { ["<leader>A"] = "@parameter.inner", },
        },
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            ["af"] = { query = "@function.outer", desc = "Around Function" },
            ["if"] = { query = "@function.inner", desc = "Inside Function" },
            ["ac"] = { query = "@class.outer", desc = "Around Class" },
            ["ic"] = { query = "@class.inner", desc = "Inside Class" },
            ["a/"] = { query = "@comment.outer", desc = "Around Comment" },
            ["i/"] = { query = "@comment.inner", desc = "Inside Comment" },
            ["aa"] = { query = "@parameter.outer", desc = "Around Argument" },
            ["ia"] = { query = "@parameter.inner", desc = "Inside Argument" },
            ["al"] = { query = "@loop.outer", desc = "Around Loop" },
            ["il"] = { query = "@loop.inner", desc = "Inside Loop" },
            ["ai"] = { query = "@conditional.outer", desc = "Around If" },
            ["ii"] = { query = "@conditional.inner", desc = "Inside If" },
          },
          -- You can choose the select mode  ('v' (default), 'V', or '<c-v>')
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = 'V',
          },
          include_surrounding_whitespace = false,
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
            ["]/"] = { query = "@comment.outer", desc = "Next comment start" },
            ["]a"] = { query = "@parameter.inner", desc = "Next parameter" },
            ["]b"] = { query = "@block.outer", desc = "Next block" },
            ["]l"] = { query = "@loop.*", desc = "Next loop part" },
            ["]i"] = { query = "@conditional.outer", desc = "Next if" },
            ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]?"] = "@comment.outer",
            ["]A"] = "@parameter.inner",
            ["]B"] = "@block.outer",
            ["]I"] = "@conditional.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[/"] = "@comment.outer",
            ["[a"] = "@parameter.inner",
            ["[b"] = "@block.outer",
            ["[i"] = "@conditional.outer",
            ["[z"] = { query = "@fold", query_group = "folds", },
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[T"] = "@class.outer",
            ["[?"] = "@comment.outer",
            ["[A"] = "@parameter.inner",
            ["[B"] = "@block.outer",
            ["[I"] = "@conditional.outer",
          },
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)

      -- Setup Folding
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.indentexpr = ""
      vim.opt.foldlevel = 20
    end,
  },
}
