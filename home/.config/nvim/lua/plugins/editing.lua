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
    opts = {
      aliases = {
        ["d"] = '"', -- double quotes
      },
      surrounds = {
        ["c"] = {
          add = { "/* ", " */" },
          find = "/%*.-%*/",
          delete = "^(/%* )().*( %*/)$",
        },
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
    -- https://github.com/monaqa/dial.nvim
    "monaqa/dial.nvim",
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group {
        -- default augends used when no group name is specified
        default = {
          augend.integer.alias.decimal,  -- nonnegative decimal number (0, 1, 2, 3, ...)
          augend.integer.alias.hex,      -- nonnegative hex number  (0x01, 0x1a1f, etc.)
          augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
          augend.constant.alias.bool,
          augend.semver.alias.semver,
        },
      }
    end,
    keys = {
      { "<C-a>",  function() require("dial.map").manipulate("increment", "normal") end,  mode = { "n" } },
      { "<C-x>",  function() require("dial.map").manipulate("decrement", "normal") end,  mode = { "n" } },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, mode = { "n" } },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, mode = { "n" } },
      { "<C-a>",  function() require("dial.map").manipulate("increment", "visual") end,  mode = { "x" } },
      { "<C-x>",  function() require("dial.map").manipulate("decrement", "visual") end,  mode = { "x" } },
      { "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, mode = { "x" } },
      { "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, mode = { "x" } },
    },
  },
  {
    -- https://github.com/NvChad/nvim-colorizer.lua
    "NvChad/nvim-colorizer.lua",
    enabled = not vim.g.vscode,
    ft = {
      "css",
      "dosini",
      "lua",
      "qss",
      "slint",
    },
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,           -- #RGB hex codes
        RRGGBB = true,        -- #RRGGBB hex codes
        names = false,        -- "Name" codes like Blue or blue
        RRGGBBAA = false,     -- #RRGGBBAA hex codes
        AARRGGBB = false,     -- 0xAARRGGBB hex codes
        rgb_fn = false,       -- CSS rgb() and rgba() functions
        hsl_fn = false,       -- CSS hsl() and hsla() functions
        css = false,          -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false,       -- Enable all CSS *functions*: rgb_fn, hsl_fn
        mode = "virtualtext", -- "foreground", "background", "virtualtext"
        tailwind = false,
        sass = { enable = false, parsers = { "css" } },
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
    -- stylua: ignore start
    keys = {
      { "<C-h>", function() require("smart-splits").move_cursor_left() end,  desc = "Move left one pane" },
      { "<C-j>", function() require("smart-splits").move_cursor_down() end,  desc = "Move down one pane" },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end,    desc = "Move up one pane" },
      { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move right one pane" },
    },
    -- stylua: ignore end
    init = function()
      vim.keymap.set("t", "<C-h>", function()
        require("smart-splits").move_cursor_left()
      end, { desc = "Move left one pane" })
      vim.keymap.set("t", "<C-j>", function()
        require("smart-splits").move_cursor_down()
      end, { desc = "Move down one pane" })
      vim.keymap.set("t", "<C-k>", function()
        require("smart-splits").move_cursor_up()
      end, { desc = "Move up one pane" })
      vim.keymap.set("t", "<C-l>", function()
        require("smart-splits").move_cursor_right()
      end, { desc = "Move right one pane" })
    end
  },
  {
    --https://github.com/jake-stewart/multicursor.nvim
    "jake-stewart/multicursor.nvim",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      -- Add or skip cursor above/below the main cursor.
      vim.keymap.set({ "n", "x" }, "<up>", function() mc.lineAddCursor(-1) end)
      vim.keymap.set({ "n", "x" }, "<down>", function() mc.lineAddCursor(1) end)
      vim.keymap.set({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end)
      vim.keymap.set({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end)

      -- Add or skip adding a new cursor by matching word/selection
      vim.keymap.set({ "n", "x" }, "<leader>n", function() mc.matchAddCursor(1) end)
      vim.keymap.set({ "n", "x" }, "<leader>N", function() mc.matchSkipCursor(1) end)

      -- Add and remove cursors with control + left click.
      vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)
      vim.keymap.set("n", "<c-leftdrag>", mc.handleMouseDrag)
      vim.keymap.set("n", "<c-leftrelease>", mc.handleMouseRelease)

      -- Disable and enable cursors.
      -- vim.keymap.set({"n", "x"}, "<c-q>", mc.toggleCursor)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

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
    end
  },
  {
    -- https://github.com/MagicDuck/grug-far.nvim
    "MagicDuck/grug-far.nvim",
    enabled = not vim.g.vscode,
    config = true,
    keys = {
      {
        "<leader>far",
        function()
          require("grug-far").open({ transient = true })
        end,
        desc = "Find/Replace",
      },
      {
        "<C-M-h>",
        function()
          require("grug-far").open({ transient = true })
        end,
        desc = "Find/Replace",
      },
      {
        "_r",
        function()
          require("grug-far").open({ transient = true })
        end,
        desc = "Find/Replace",
      },
    },
    opts = {
      windowCreationCommand = "vsplit",
    },
  },
}
