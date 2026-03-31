return {
  {
    "dmtrKovalenko/fff.nvim",
    enabled = not vim.g.vscode,
    -- build = "nix run .#release",
    build = "cargo build --release",
    opts = {
      prompt = "🔎 ",
      debug = {
        enabled = false,
        show_scores = true,
      },
      keymaps = {
        close = "<C-C>",
        toggle_debug = "<F1>",
      },
    },
    lazy = false,
    keys = {
      {
        "<leader><space>",
        function() require("fff").find_files() end,
        desc = "FFFind files",
      }
    }
  },
  {
    -- https://github.com/kylechui/nvim-surround
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {
      aliases = {
        ["d"] = '"', -- double quotes
      },
    },
    -- ys
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
    enabled = not vim.g.vscode,
    lazy = false,
    dependencies = {
      -- "hiasr/vim-zellij-navigator.nvim",
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
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = false,
    branch = "main",
    opts = {
      select = {
        lookahead = true,
        include_surrounding_whitespace = true,
        selection_modes = {
          -- <c-v> for blockwise
          ["@parameter.outer"] = "v",
          ["@class.outer"] = "V",
          ["@function.outer"] = "V",
        },
      },
      move = {
        set_jumps = true,
      },
    },
    keys = {
      -- Selection
      { "af", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects") end, mode = { "o", "x" }, desc = "Around Function" },
      { "if", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects") end, mode = { "o", "x" }, desc = "Inside Function" },
      { "ac", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects") end, mode = { "o", "x" }, desc = "Around Class" },
      { "ic", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects") end, mode = { "o", "x" }, desc = "Inside Class" },
      { "a/", function() require("nvim-treesitter-textobjects.select").select_textobject("@comment.outer", "textobjects") end, mode = { "o", "x" }, desc = "Around Comment" },
      { "i/", function() require("nvim-treesitter-textobjects.select").select_textobject("@comment.inner", "textobjects") end, mode = { "o", "x" }, desc = "Inside Comment" },
      { "aa", function() require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects") end, mode = { "o", "x" }, desc = "Around Parameter/Argument" },
      { "ia", function() require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects") end, mode = { "o", "x" }, desc = "Inside Parameter/Argument" },
      { "al", function() require("nvim-treesitter-textobjects.select").select_textobject("@loop.outer", "textobjects") end, mode = { "o", "x" }, desc = "Around Loop" },
      { "il", function() require("nvim-treesitter-textobjects.select").select_textobject("@loop.inner", "textobjects") end, mode = { "o", "x" }, desc = "Inside Loop" },
      { "ai", function() require("nvim-treesitter-textobjects.select").select_textobject("@conditional.outer", "textobjects") end, mode = { "o", "x" }, desc = "Around If" },
      { "ii", function() require("nvim-treesitter-textobjects.select").select_textobject("@conditional.inner", "textobjects") end, mode = { "o", "x" }, desc = "Inside If" },
      { "as", function() require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals") end, mode = { "o", "x" }, desc = "Around Scope" },
      -- Move
      { "]f", function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Next Function"},
      { "[f", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Previous Function"},
      { "]c", function() require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Next Class"},
      { "[c", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Previous Class"},
      { "]l", function() require("nvim-treesitter-textobjects.move").goto_next_start({"@loop.inner", "@loop.outer"}, "textobjects") end, mode = { "n", "x", "o" }, desc = "Next Loop"},
      { "]s", function() require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals") end, mode = { "n", "x", "o" }, desc = "Next Local"},
      { "]z", function() require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds") end, mode = { "n", "x", "o" }, desc = "Next Fold"},
      { "]i", function() require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Next Conditional"},
      { "[i", function() require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Previous Conditional"},
      -- Repeat Move
      { ";", function() require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move_next() end, mode = { "n", "x", "o" }, desc = "Repeat Next Move"},
      { ",", function() require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move_previous() end, mode = { "n", "x", "o" }, desc = "Repeat Previous Move"},
      -- Swap
      { "<leader>a", function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end, mode = { "n" }, desc = "Swap Next Argument" },
      { "<leader>A", function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner") end, mode = { "n" }, desc = "Swap Previous Argument" },
    },
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true

      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true, desc = "Built-In f" })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true, desc = "Built-In F" })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true, desc = "Built-In t" })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true, desc = "Built-In T" })
    end,
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)
    end,
  },
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- "MeanderingProgrammer/treesitter-modules.nvim",
    branch = "main",
    lazy = false,
    -- event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    cmd = { "TSUpdateSync" },
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
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<A-o>",
          node_incremental = "<A-o>",
          scope_incremental = "<A-O>",
          node_decremental = "<A-i>",
        }
      },
      textobjects = textobjects,
    },
    init = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      -- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"

      vim.opt.foldenable = true
      vim.opt.foldlevel = 20
      -- vim.opt.foldlevelstart = 20
      -- vim.opt.indentexpr = "nvim_treesitter#indent()"

      vim.g._ts_force_sync_parsing = false
    end,
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
    end,
  },
}
