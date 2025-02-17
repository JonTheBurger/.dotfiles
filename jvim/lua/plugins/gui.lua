return {
  {
    -- https://github.com/stevearc/overseer.nvim
    "stevearc/overseer.nvim",
    keys = {
      { "<leader>Wx", "<cmd>OverseerRun<CR>", desc = "Execute Task" },
      { "<leader>Wo", "<cmd>OverseerToggle<CR>", desc = "Task Output" },
      { "<leader>M", "<cmd>OverseerRun<CR>", desc = "Execute Task" },
      { "<leader>O", "<cmd>OverseerToggle<CR>", desc = "Task Output" },
    },
    opts = {
      templates = { "make", "vscode", "cargo", "just", },
      task_list = {
        max_width = { 100, 0.4 },
        min_width = { 30, 0.2 },
        max_height = { 20, 0.2 },
        bindings = {
          ["<C-h>"] = false,
          ["<C-j>"] = false,
          ["<C-k>"] = false,
          ["<C-l>"] = false,
          ["<M-h>"] = "DecreaseDetail",
          ["<M-j>"] = "ScrollOutputDown",
          ["<M-k>"] = "ScrollOutputUp",
          ["<M-l>"] = "IncreaseDetail",
        },
      },
    },
  },
  {
    -- https://github.com/mbbill/undotree
    "mbbill/undotree",
    event = "BufEnter",
    keys = {
      { "<leader>u",  "<cmd>UndotreeToggle<CR>", desc = "Toggle Undo Tree" },
      { "<leader>Wu", "<cmd>Outline<CR>",        desc = "Undo Tree" },
    },
    init = function()
      vim.g.undotree_WindowLayout = 4
    end,
  },
  {
    -- https://github.com/folke/trouble.nvim
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      { "<leader>Wd", "<cmd>Trouble diagnostics<CR>", desc = "Diagnostics (Trouble)" },
    },
    opts = {
      padding = false,
      mode = "document_diagnostics",
    },
  },
  {
    -- https://github.com/hedyhli/outline.nvim
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>y",  "<cmd>Outline<CR>", desc = "Toggle Symbol Outline" },
      { "<leader>Wy", "<cmd>Outline<CR>", desc = "Symbol Outline" },
    },
    opts = {
      symbol_folding = {
        autofold_depth = 5,
      },
    }
  },
  {
    -- https://github.com/MagicDuck/grug-far.nvim
    "MagicDuck/grug-far.nvim",
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
        "<leader>Wr",
        function()
          require("grug-far").open({ transient = true })
        end,
        desc = "Find/Replace",
      },
    },
    opts = {
      windowCreationCommand = "vsplit"
    },
  },
  {
    -- https://github.com/lewis6991/gitsigns.nvim
    "lewis6991/gitsigns.nvim",
    keys = {
      { "<leader>gb", "<cmd>Gitsigns blame<CR>",                     desc = "Git Blame Toggle" },
      { "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Git Blame Toggle" },
      { "<leader>Wb", "<cmd>Gitsigns blame<CR>",                     desc = "Git Blame" },
    },
    cmd = {
      "Gitsigns",
    },
    opts = {},
  },
  {
    -- https://github.com/folke/which-key.nvim
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    opts = {
      prefix = "<leader>",
    },
  },
  {
    -- https://github.com/unblevable/quick-scope
    "unblevable/quick-scope",
    init = function()
      vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
    end,
  },
  {
    -- https://github.com/NvChad/nvim-colorizer.lua
    "NvChad/nvim-colorizer.lua",
    ft = {
      "css",
      "dosini",
      "lua",
    },
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,          -- #RGB hex codes
        RRGGBB = true,       -- #RRGGBB hex codes
        names = true,        -- "Name" codes like Blue or blue
        RRGGBBAA = false,    -- #RRGGBBAA hex codes
        AARRGGBB = false,    -- 0xAARRGGBB hex codes
        rgb_fn = false,      -- CSS rgb() and rgba() functions
        hsl_fn = false,      -- CSS hsl() and hsla() functions
        css = false,         -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false,      -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        -- Available methods are false / true / "normal" / "lsp" / "both"
        -- True is same as normal
        tailwind = false,                                -- Enable tailwind colors
        -- parsers can contain values used in |user_default_options|
        sass = { enable = false, parsers = { "css" }, }, -- Enable sass colors
        virtualtext = "■",
        -- update color values even if buffer is not focused
        -- example use: cmp_menu, cmp_docs
        always_update = false
      },
      -- all the sub-options of filetypes apply to buftypes
      buftypes = {},
    },
  },
}
