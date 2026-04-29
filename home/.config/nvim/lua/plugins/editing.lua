---@module "lazy"
---@type LazyPluginSpec[]
return {
  {
    -- https://github.com/windwp/nvim-autopairs
    "windwp/nvim-autopairs",
    enabled = true,
    event = "InsertEnter",
    opts = {
      disable_filetype = { "snacks_picker_input", "dap-repl" },
      map_cr = true,
    },
  },
  {
    -- https://github.com/kylechui/nvim-surround
    "kylechui/nvim-surround",
    event = "VeryLazy",
    ---@module "nvim-surround"
    ---@type user_options
    opts = {
      aliases = {
        ["d"] = '"', -- double quotes
      },
      surrounds = {
        ["c"] = {
          add = { "/* ", " */" },
          find = "/%*.-%*/",
          delete = "^(/%*%s*)().-(%s*%*/)()$",
          change = {
            target = "^(/%*%s*)().-(%s*%*/)()$",
          },
        },
      },
    },
    init = function()
      -- stylua: ignore start
      vim.keymap.set("n", "gs", "<Plug>(nvim-surround-normal)aw", { desc = "Surround around word" })
      vim.keymap.set("n", "gS", "<Plug>(nvim-surround-normal)aW", { desc = "Surround around WORD" })
      -- stylua: ignore end
    end,
  },
  {
    -- https://github.com/monaqa/dial.nvim
    "monaqa/dial.nvim",
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        -- default augends used when no group name is specified
        default = {
          augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
          augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
          augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
          augend.constant.alias.bool,
          augend.semver.alias.semver,
        },
      })
    end,
    keys = {
      -- stylua: ignore start
      { "<C-a>",  function() require("dial.map").manipulate("increment", "normal") end,  mode = { "n" }, desc = "Increment" },
      { "<C-x>",  function() require("dial.map").manipulate("decrement", "normal") end,  mode = { "n" }, desc = "Decrement" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, mode = { "n" }, desc = "Increment" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, mode = { "n" }, desc = "Decrement" },
      { "<C-a>",  function() require("dial.map").manipulate("increment", "visual") end,  mode = { "x" }, desc = "Increment" },
      { "<C-x>",  function() require("dial.map").manipulate("decrement", "visual") end,  mode = { "x" }, desc = "Decrement" },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode = { "x" }, desc = "Increment" },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode = { "x" }, desc = "Decrement" },
      -- stylua: ignore end
    },
  },
  {
    -- https://github.com/catgoose/nvim-colorizer.lua
    "catgoose/nvim-colorizer.lua",
    enabled = not vim.g.vscode,
    ft = {
      "css",
      "dosini",
      "lua",
      "qss",
      "slint",
    },
    ---@module "colorizer"
    ---@type colorizer.SetupOptions
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes like Blue or blue
        RRGGBBAA = false, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        mode = "virtualtext", -- "foreground", "background", "virtualtext"
        tailwind = true,
        sass = { enable = true, parsers = { "css" } },
        virtualtext = "■",
        always_update = false,
      },
      buftypes = {},
    },
  },
  {
    -- https://github.com/mrjones2014/smart-splits.nvim
    "mrjones2014/smart-splits.nvim",
    enabled = not vim.g.vscode,
    lazy = false,
    dependencies = {
      -- "hiasr/vim-zellij-navigator.nvim",
    },
    keys = {
      -- stylua: ignore start
      { "<C-h>", function() require("smart-splits").move_cursor_left() end,  mode = { "n", "v", "t" }, desc = "Move left one pane" },
      { "<C-j>", function() require("smart-splits").move_cursor_down() end,  mode = { "n", "v", "t" }, desc = "Move down one pane" },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end,    mode = { "n", "v", "t" }, desc = "Move up one pane" },
      { "<C-l>", function() require("smart-splits").move_cursor_right() end, mode = { "n", "v", "t" }, desc = "Move right one pane" },
      -- stylua: ignore end
    },
  },
  {
    --https://github.com/jake-stewart/multicursor.nvim
    "jake-stewart/multicursor.nvim",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      -- Add or skip cursor above/below the main cursor.
      vim.keymap.set({ "n", "x" }, "<up>", function() mc.lineAddCursor(-1) end, { desc = "Add Cursor " })
      vim.keymap.set({ "n", "x" }, "<down>", function() mc.lineAddCursor(1) end, { desc = "Add Cursor " })
      vim.keymap.set({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end, { desc = "Skip Cursor " })
      vim.keymap.set({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end, { desc = "Skip Cursor " })

      -- Add or skip adding a new cursor by matching word/selection
      vim.keymap.set({ "n", "x" }, "<leader>n", function() mc.matchAddCursor(1) end, { desc = "Add Cursor on Next Word" })
      vim.keymap.set({ "n", "x" }, "<leader>N", function() mc.matchSkipCursor(1) end, { desc = "Add Cursor on Previous Word" })

      -- Add and remove cursors with control + left click.
      vim.keymap.set("n", "<C-leftmouse>", mc.handleMouse, { desc = "Add Cursor" })
      vim.keymap.set("n", "<C-leftdrag>", mc.handleMouseDrag, { desc = "Add Cursor" })
      vim.keymap.set("n", "<C-leftrelease>", mc.handleMouseRelease, { desc = "Finish Cursor Add" })

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)

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
      vim.api.nvim_set_hl(0, "MultiCursorSign", { link = "SignColumn" })
      vim.api.nvim_set_hl(0, "MultiCursorMatchPreview", { link = "Search" })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      vim.api.nvim_set_hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },
  {
    -- https://github.com/MagicDuck/grug-far.nvim
    "MagicDuck/grug-far.nvim",
    enabled = not vim.g.vscode,
    keys = {
      -- stylua: ignore start
      { "<leader>far", function() require("grug-far").open({ transient = true }) end, desc = "Find/Replace", },
      { "_r",          function() require("grug-far").open({ transient = true }) end, desc = "Find/Replace", },
      -- stylua: ignore end
    },
    ---@module "grug-far.nvim"
    ---@type grug.far.Options
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      windowCreationCommand = "vsplit",
    },
  },
}
