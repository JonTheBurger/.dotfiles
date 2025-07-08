return {
  {
    -- https://github.com/stevearc/overseer.nvim
    "stevearc/overseer.nvim",
    keys = {
      { "<leader>Wb", "<cmd>OverseerRun<CR>",    desc = "Execute Task" },
      { "<leader>Wo", "<cmd>OverseerToggle<CR>", desc = "Task Output" },
      { "<leader>B",  "<cmd>OverseerRun<CR>",    desc = "Execute Task" },
      { "<leader>O",  "<cmd>OverseerToggle<CR>", desc = "Task Output" },
    },
    ---@type overseer.Config
    opts = {
      -- templates = { "make", "vscode", "cargo", "just", "user.run_script", },
      templates = { "builtin", "user.run_script", },
      task_list = {
        max_width = { 100, 0.4 },
        min_width = { 30, 0.2 },
        max_height = { 20, 0.2 },
        bindings = {
          ["<C-h>"] = false,
          ["<C-j>"] = false,
          ["<C-k>"] = false,
          ["<C-l>"] = false,
          ["<C-Left>"] = "DecreaseDetail",
          ["<C-Down>"] = "ScrollOutputDown",
          ["<C-Up>"] = "ScrollOutputUp",
          ["<C-Right>"] = "IncreaseDetail",
        },
      },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)
      -- https://github.com/stevearc/overseer.nvim/blob/master/doc/reference.md#add_template_hookopts-hook
      overseer.add_template_hook(
        { name = "^make.*", },
        function(task_defn, util)
          util.add_component(task_defn, { "on_output_parse", problem_matcher = "$gcc" })
          util.add_component(task_defn, { "on_result_diagnostics" })
          util.add_component(task_defn, { "on_result_diagnostics_trouble" })
        end)

      -- https://github.com/stevearc/overseer.nvim/blob/master/doc/tutorials.md#run-a-file-on-save
      vim.api.nvim_create_user_command("Rerun", function()
        local overseer = require("overseer")
        overseer.run_template({ name = "run script" }, function(task)
          if task then
            task:add_component({ "restart_on_save", paths = {vim.fn.expand("%:p")} })
            local main_win = vim.api.nvim_get_current_win()
            overseer.run_action(task, "open vsplit")
            vim.api.nvim_set_current_win(main_win)
          else
            vim.notify("Rerun not supported for filetype " .. vim.bo.filetype, vim.log.levels.ERROR)
          end
        end)
      end, {})
    end,
  },
  {
    -- https://github.com/mbbill/undotree
    "mbbill/undotree",
    event = "BufEnter",
    keys = {
      { "<leader>U",  "<cmd>UndotreeToggle<CR>", desc = "Toggle Undo Tree" },
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
      { "<leader>Wd", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
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
    },
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
      windowCreationCommand = "vsplit",
    },
  },
  {
    -- https://github.com/sindrets/diffview.nvim
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>",        desc = "Git DiffView Open" },
      { "<leader>gD", "<cmd>DiffviewClose<CR>",       desc = "Git DiffView Close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "Git FileHistory" },
      { "<leader>gxo", function() require("diffview.actions").conflict_choose("ours") end, desc = "Git Conflict accept ours" },
      { "<leader>gxt", function() require("diffview.actions").conflict_choose("theirs") end, desc = "Git Conflict accept theirs" },
      { "<leader>gxb", function() require("diffview.actions").conflict_choose("base") end, desc = "Git Conflict accept base" },
      { "<leader>gxa", function() require("diffview.actions").conflict_choose("all") end, desc = "Git Conflict accept all" },
    },
    cmd = {
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewLog",
      "DiffviewOpen",
      "DiffviewRefresh",
      "DiffviewToggleFiles",
    },
  },
  {
    -- https://github.com/lewis6991/gitsigns.nvim
    "lewis6991/gitsigns.nvim",
    keys = {
      { "<leader>gb", "<cmd>Gitsigns blame<CR>",                     desc = "Git Blame Toggle" },
      { "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Git Blame Line Toggle" },
      { "<leader>Wb", "<cmd>Gitsigns blame<CR>",                     desc = "Git Blame" },
      { "]g",         "<cmd>Gitsigns nav_hunk next<CR>",             desc = "Next Git Change" },
      { "[g",         "<cmd>Gitsigns nav_hunk prev<CR>",             desc = "Previous Git Change" },
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
      sort = { "alphanum", "local", "order", "group", "mod" },
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
    -- https://github.com/jontheburger/nvim-elf-file
    "jontheburger/nvim-elf-file",
    opts = {},
  }
}
