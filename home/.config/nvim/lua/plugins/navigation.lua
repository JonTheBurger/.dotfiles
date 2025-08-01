return {
  {
    -- https://github.com/kylechui/nvim-surround
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {
      aliases = {
        ["d"] = '"', -- double quotes
      },
    },
    init = function()
      -- stylua: ignore start
      vim.keymap.set("n", "gs", "<Plug>(nvim-surround-normal)aw", { noremap = true, desc = "Surround around word" })
      vim.keymap.set("n", "gS", "<Plug>(nvim-surround-normal)aW", { noremap = true, desc = "Surround around WORD" })
      -- stylua: ignore end
    end,
  },
  {
    -- https://github.com/mrjones2014/smart-splits.nvim
    "mrjones2014/smart-splits.nvim",
    dependencies = {
      "hiasr/vim-zellij-navigator.nvim",
    },
    -- stylua: ignore start
    keys = {
      { "<C-h>", function() require("smart-splits").move_cursor_left() end,  desc = "Move left one pane" },
      { "<C-j>", function() require("smart-splits").move_cursor_down() end,  desc = "Move down one pane" },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end,    desc = "Move up one pane" },
      { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move right one pane" },
    },
    -- stylua: ignore end
  },
  {
    --https://github.com/jake-stewart/multicursor.nvim
    "jake-stewart/multicursor.nvim",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      -- Add or skip cursor above/below the main cursor.
      vim.keymap.set({"n", "x"}, "<up>", function() mc.lineAddCursor(-1) end)
      vim.keymap.set({"n", "x"}, "<down>", function() mc.lineAddCursor(1) end)
      vim.keymap.set({"n", "x"}, "<leader><up>", function() mc.lineSkipCursor(-1) end)
      vim.keymap.set({"n", "x"}, "<leader><down>", function() mc.lineSkipCursor(1) end)

      -- Add or skip adding a new cursor by matching word/selection
      vim.keymap.set({"n", "x"}, "<leader>n", function() mc.matchAddCursor(1) end)
      vim.keymap.set({"n", "x"}, "<leader>m", function() mc.matchSkipCursor(1) end)
      vim.keymap.set({"n", "x"}, "<leader>N", function() mc.matchAddCursor(-1) end)
      vim.keymap.set({"n", "x"}, "<leader>MM", function() mc.matchSkipCursor(-1) end)

      -- Add and remove cursors with control + left click.
      vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)
      vim.keymap.set("n", "<c-leftdrag>", mc.handleMouseDrag)
      vim.keymap.set("n", "<c-leftrelease>", mc.handleMouseRelease)

      -- Disable and enable cursors.
      vim.keymap.set({"n", "x"}, "<c-q>", mc.toggleCursor)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)

        -- Select a different cursor as the main one.
        layerSet({"n", "x"}, "<left>", mc.prevCursor)
        layerSet({"n", "x"}, "<right>", mc.nextCursor)

        -- Delete the main cursor.
        layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
      vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
      vim.api.nvim_set_hl(0, "MultiCursorSign", { link = "SignColumn"})
      vim.api.nvim_set_hl(0, "MultiCursorMatchPreview", { link = "Search" })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
    end
  },
  {
    -- https://github.com/chrisgrieser/nvim-various-textobjs
    "chrisgrieser/nvim-various-textobjs",
    keys = {
      { "i$", "<cmd>lua require('various-textobjs').lineCharacterwise('inner')<CR>",    mode = { "o", "x" } },
      { "a$", "<cmd>lua require('various-textobjs').lineCharacterwise('outer')<CR>",    mode = { "o", "x" } },
      { "as", "<cmd>lua require('various-textobjs').subword('outer')<CR>",              mode = { "o", "x" } },
      { "is", "<cmd>lua require('various-textobjs').subword('inner')<CR>",              mode = { "o", "x" } },
      { "ik", "<cmd>lua require('various-textobjs').key('inner')<CR>",                  mode = { "o", "x" } },
      { "ak", "<cmd>lua require('various-textobjs').key('outer')<CR>",                  mode = { "o", "x" } },
      { "iv", "<cmd>lua require('various-textobjs').value('inner')<CR>",                mode = { "o", "x" } },
      { "av", "<cmd>lua require('various-textobjs').value('outer')<CR>",                mode = { "o", "x" } },
      { "i>", "<cmd>lua require('various-textobjs').indentation('inner', 'inner')<CR>", mode = { "o", "x" } },
      { "a>", "<cmd>lua require('various-textobjs').indentation('outer', 'outer')<CR>", mode = { "o", "x" } },
      { "i~", "<cmd>lua require('various-textobjs').mdFencedCodeBlock('inner')<CR>",    mode = { "o", "x" } },
      { "a~", "<cmd>lua require('various-textobjs').mdFencedCodeBlock('outer')<CR>",    mode = { "o", "x" } },
    },
  },
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
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
        "markdown_inline",
        "python",
        "rust",
        "yaml",
      },
      highlight = {
        enable = true,
        disable = {},
      },
      indent = {
        enable = true,
        disable = { "rst" },
      },
      incremental_selection = { enable = true },
      textobjects = {
        swap = {
          enable = true,
          swap_next = { ["<leader>a"] = "@parameter.inner" },
          swap_previous = { ["<leader>A"] = "@parameter.inner" },
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
            ["@parameter.outer"] = "v",
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
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
            ["[z"] = { query = "@fold", query_group = "folds" },
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
      vim.opt.foldlevel = 20
      vim.opt.indentexpr = "nvim_treesitter#indent()"

      vim.g._ts_force_sync_parsing = true
    end,
  },
}
