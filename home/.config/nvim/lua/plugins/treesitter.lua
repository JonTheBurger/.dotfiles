--- @module "lazy"
--- @type LazyPluginSpec[]
return {
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    lazy = false,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    --- @module "nvim-treesitter.config"
    --- @type TSConfig
    opts = {
      auto_install = true,
      sync_install = false,
      ignore_install = {},
      modules = {},
      highlight = {
        enable = true,
        disable = {},
      },
      indent = {
        enable = false,
        disable = { "rst" },
      },
    },
    init = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      -- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
      vim.opt.foldenable = true
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99

      vim.g._ts_force_sync_parsing = false
    end,
    --- @module "nvim-treesitter.config"
    --- @param opts TSConfig
    config = function(opts)
      local ts = require("nvim-treesitter.config")
      ts.setup(opts)

      local installed = ts.get_installed()
      local ensure_installed = require("config.preferences").ts_languages
      local needed = vim.tbl_filter(function(lang) return not vim.tbl_contains(installed, lang) end, ensure_installed)
      local parser = require("nvim-treesitter.install")
      for _, lang in ipairs(needed) do
        parser.install(lang)
      end
    end,
  },
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = false,
    branch = "main",
    --- @module "nvim-treesitter-textobjects.config"
    --- @type TSTextObjects.Config
    opts = {
      select = {
        lookahead = true,
        lookbehind = true,
        include_surrounding_whitespace = true,
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@class.outer"] = "V", -- linewise
          ["@function.outer"] = "V", -- <c-v> for blockwise
        },
      },
      move = {
        set_jumps = true,
      },
    },
    keys = {
      -- stylua: ignore start
      -- Selection
      { "af", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects") end,    mode = { "o", "x" }, desc = "Around Function" },
      { "if", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects") end,    mode = { "o", "x" }, desc = "Inside Function" },
      { "ac", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects") end,       mode = { "o", "x" }, desc = "Around Class" },
      { "ic", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects") end,       mode = { "o", "x" }, desc = "Inside Class" },
      { "a#", function() require("nvim-treesitter-textobjects.select").select_textobject("@comment.outer", "textobjects") end,     mode = { "o", "x" }, desc = "Around Comment" },
      { "i#", function() require("nvim-treesitter-textobjects.select").select_textobject("@comment.inner", "textobjects") end,     mode = { "o", "x" }, desc = "Inside Comment" },
      { "aa", function() require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects") end,   mode = { "o", "x" }, desc = "Around Parameter/Argument" },
      { "ia", function() require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects") end,   mode = { "o", "x" }, desc = "Inside Parameter/Argument" },
      { "al", function() require("nvim-treesitter-textobjects.select").select_textobject("@loop.outer", "textobjects") end,        mode = { "o", "x" }, desc = "Around Loop" },
      { "il", function() require("nvim-treesitter-textobjects.select").select_textobject("@loop.inner", "textobjects") end,        mode = { "o", "x" }, desc = "Inside Loop" },
      { "av", function() require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals") end,            mode = { "o", "x" }, desc = "Around Scope" },
      { "ai", function() require("nvim-treesitter-textobjects.select").select_textobject("@conditional.outer", "textobjects") end, mode = { "o", "x" }, desc = "Around If" },
      { "ii", function() require("nvim-treesitter-textobjects.select").select_textobject("@conditional.inner", "textobjects") end, mode = { "o", "x" }, desc = "Inside If" },
      -- Move
      { "[a", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.inner", "textobjects") end,   mode = { "n", "x", "o" }, desc = "Previous Parameter/Argument" },
      { "]a", function() require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.inner", "textobjects") end,       mode = { "n", "x", "o" }, desc = "Next Parameter/Argument" },
      { "[f", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects") end,    mode = { "n", "x", "o" }, desc = "Previous Function" },
      { "]f", function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects") end,        mode = { "n", "x", "o" }, desc = "Next Function" },
      { "[c", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects") end,       mode = { "n", "x", "o" }, desc = "Previous Class" },
      { "]c", function() require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects") end,           mode = { "n", "x", "o" }, desc = "Next Class" },
      { "[v", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@local.scope", "locals") end,            mode = { "n", "x", "o" }, desc = "Next Local" },
      { "]v", function() require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals") end,                mode = { "n", "x", "o" }, desc = "Next Local" },
      { "[z", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@fold", "folds") end,                    mode = { "n", "x", "o" }, desc = "Next Fold" },
      { "]z", function() require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds") end,                        mode = { "n", "x", "o" }, desc = "Next Fold" },
      { "[i", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@conditional.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "Previous Conditional" },
      { "]i", function() require("nvim-treesitter-textobjects.move").goto_next_start("@conditional.outer", "textobjects") end,     mode = { "n", "x", "o" }, desc = "Next Conditional" },
      { "[l", function() require("nvim-treesitter-textobjects.move").goto_previous_start({ "@loop.inner", "@loop.outer" }, "textobjects") end, mode = { "n", "x", "o" }, desc = "Next Loop" },
      { "]l", function() require("nvim-treesitter-textobjects.move").goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects") end,     mode = { "n", "x", "o" }, desc = "Next Loop" },
      -- Swap
      { "<leader>a", function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end,     mode = { "n" }, desc = "Swap Next Argument" },
      { "<leader>A", function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner") end, mode = { "n" }, desc = "Swap Previous Argument" },
      -- Repeat Move
      { ";", function() require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move_next()     vim.cmd("normal! zz") end, mode = { "n", "x", "o" }, desc = "Repeat Next Move" },
      { ",", function() require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move_previous() vim.cmd("normal! zz") end, mode = { "n", "x", "o" }, desc = "Repeat Previous Move" },
      -- stylua: ignore end
    },
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true
      -- `expr = true` is not supported in lazy keys
      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true, desc = "Built-In f" })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true, desc = "Built-In F" })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true, desc = "Built-In t" })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true, desc = "Built-In T" })
    end,
  },
  {
    -- https://github.com/nvim-treesitter/nvim-treesitter-context
    "nvim-treesitter/nvim-treesitter-context",
    enabled = not vim.g.vscode,
    --- @module "treesitter-context.config"
    --- @type TSContext.Config
    opts = {
      max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 50, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      multiline_threshold = 5, -- Maximum number of lines to show for a single context
      trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
    },
    --- @module "treesitter-context.config"
    --- @param opts TSContext.Config
    config = function(opts)
      require("treesitter-context").setup(opts)
      vim.api.nvim_set_hl(0, "TreesitterContext", { bold = true })
    end,
  },
  {
    -- https://github.com/chrisgrieser/nvim-various-textobjs
    "chrisgrieser/nvim-various-textobjs",
    --- @module "various-textobjs.config"
    --- @type VariousTextobjs.Config
    opts = {
      keymaps = {
        useDefaults = false,
      },
      ---@diagnostic disable-next-line: missing-fields
    },
    keys = {
      -- stylua: ignore start
      { "i$", function() require("various-textobjs").lineCharacterwise("inner") end,    mode = { "o", "x" } },
      { "a$", function() require("various-textobjs").lineCharacterwise("outer") end,    mode = { "o", "x" } },
      { "au", function() require("various-textobjs").subword("outer") end,              mode = { "o", "x" } },
      { "iu", function() require("various-textobjs").subword("inner") end,              mode = { "o", "x" } },
      { "ik", function() require("various-textobjs").key("inner") end,                  mode = { "o", "x" } },
      { "ak", function() require("various-textobjs").key("outer") end,                  mode = { "o", "x" } },
      { "iv", function() require("various-textobjs").value("inner") end,                mode = { "o", "x" } },
      { "av", function() require("various-textobjs").value("outer") end,                mode = { "o", "x" } },
      { "i>", function() require("various-textobjs").indentation("inner", "inner") end, mode = { "o", "x" } },
      { "a>", function() require("various-textobjs").indentation("outer", "outer") end, mode = { "o", "x" } },
      { "i~", function() require("various-textobjs").mdFencedCodeBlock("inner") end,    mode = { "o", "x" } },
      { "a~", function() require("various-textobjs").mdFencedCodeBlock("outer") end,    mode = { "o", "x" } },
      -- stylua: ignore end
    },
  },
}
