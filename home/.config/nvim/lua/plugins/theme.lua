---@module "config.preferences"
---@type jvim.Preferences
local prefs = require("config.prefs")
local CLICKABLE_WIDGETS = prefs.clickable_status_line
local COLORS = prefs.colors
local buffer_not_empty = function() return vim.fn.empty(vim.fn.expand("%:t")) ~= 1 end
local hide_in_width = function() return vim.fn.winwidth(0) > 80 end
local present = function(text) return "[" .. (text and text or "?") .. "]" end

---@module "lazy"
---@type LazyPluginSpec[]
return {
  {
    -- https://github.com/folke/which-key.nvim
    "folke/which-key.nvim",
    enabled = not vim.g.vscode,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    keys = {
      -- stylua: ignore start
      { "<leader>hk", function() require("which-key").show() end, mode = { "n", "x" }, desc = "Hover Keymap" },
      -- stylua: ignore end
    },
    ---@module "which-key"
    ---@type wk.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      sort = { "group" },
      spec = {
        { "<leader>L", group = "Lua", icon = "" },
        { "<leader>M", group = "Markdown", icon = "" },
        { "<leader>W", group = "Wiki", icon = "" },
        { "<leader>a", group = "AI", icon = "󰚩" },
        { "<leader>b", group = "Build", icon = "" },
        { "<leader>c", group = "Create / C++", icon = "󰙲" },
        { "<leader>d", group = "Debug / Delete", icon = "" },
        { "<leader>f", group = "Find", icon = "" },
        { "<leader>g", group = "Git", icon = "" },
        { "<leader>gx", group = "Conflicts", icon = "" },
        { "<leader>h", group = "Hover", icon = "󰉧" },
        { "<leader>o", group = "Options", icon = "" },
        { "<leader>s", group = "Search", icon = "" },
        { "<leader>t", group = "Test", icon = "󰂖" },
        { "<leader>T", group = "To Do", icon = "" },
        { "<leader>w", group = "Warnings / Wrap", icon = "" },
      },
      icons = {
        mappings = true,
        rules = {
          { pattern = "next", icon = "" },
          { pattern = "prev", icon = "" },
          { pattern = "cmake", icon = "󰙲" },
          { pattern = "comment", icon = "󰆁" },
          { pattern = "coverage", icon = "" },
          { pattern = "cursor", icon = "󰗧" },
          { pattern = "debug", icon = "" },
          { pattern = "delete", icon = "" },
          { pattern = "diagnostic", icon = "" },
          { pattern = "error", icon = "" },
          { pattern = "exe", icon = "" },
          { pattern = "file", icon = "󰈮" },
          { pattern = "find", icon = "" },
          { pattern = "format", icon = "" },
          { pattern = "function", icon = "󰡱" },
          { pattern = "git", icon = "" },
          { pattern = "jump", icon = "󱗈" },
          { pattern = "move", icon = "󱗈" },
          { pattern = "pick", icon = "󰮫" },
          { pattern = "replace", icon = "" },
          { pattern = "run", icon = "" },
          { pattern = "search", icon = "" },
          { pattern = "select", icon = "󰮫" },
          { pattern = "split", icon = "󰃻" },
          { pattern = "swap", icon = "󰓡" },
          { pattern = "test", icon = "󰂖" },
          { pattern = "trim", icon = "" },
          { pattern = "warn", icon = "" },
          { pattern = "wrap", icon = "󰣁" },
        },
      },
    },
  },
  {
    -- https://github.com/mvllow/modes.nvim
    "mvllow/modes.nvim",
    opts = {
      colors = {
        bg = "", -- Optional bg param, defaults to Normal hl group
        copy = COLORS.cyan,
        delete = COLORS.red,
        change = COLORS.orange, -- Optional param, defaults to delete
        format = COLORS.blue,
        insert = COLORS.cyan,
        replace = COLORS.purple,
        select = COLORS.magenta, -- Optional param, defaults to visual
        visual = COLORS.green,
      },
      line_opacity = 0.25,
    },
  },
  {
    -- https://github.com/nvim-zh/colorful-winsep.nvim
    "nvim-zh/colorful-winsep.nvim",
    event = { "WinLeave" },
    opts = {
      animate = {
        ---@type "shift"|"progressive"|false
        enabled = "shift",
      },
    },
  },
  {
    -- https://github.com/folke/noice.nvim
    "folke/noice.nvim",
    ---@module "noice.config"
    ---@type NoiceConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      messages = {
        view_search = false,
      },
      ---@diagnostic disable-next-line: missing-fields
      presets = {
        bottom_search = true,
        command_palette = false,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      routes = {
        { filter = { event = "msg_show", kind = "", find = "written" }, view = "mini" },
        { filter = { event = "msg_show", kind = "", find = "fewer lines" }, view = "mini" },
        { filter = { event = "msg_show", find = "^E486: Pattern not found" }, view = "mini" },
        { filter = { event = "msg_show", find = "search hit BOTTOM" }, skip = true },
        { filter = { event = "msg_show", find = "search hit TOP" }, skip = true },
        { filter = { find = ".*inlayHint is not supported.*" }, skip = true },
        { filter = { find = "No signature help" }, skip = true },
      },
    },
  },
  {
    -- https://github.com/sphamba/smear-cursor.nvim
    "sphamba/smear-cursor.nvim",
    event = { "BufReadPost" },
    opts = {
      enabled = false,
      stiffness = 0.8,
      trailing_stiffness = 0.6,
      stiffness_insert_mode = 0.7,
      trailing_stiffness_insert_mode = 0.7,
      damping = 0.95,
      damping_insert_mode = 0.95,
      distance_stop_animating = 0.5,
    },
  },
  {
    -- https://github.com/catppuccin/nvim
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    ---@module "catppuccin"
    ---@type CatppuccinOptions
    opts = {
      auto_integrations = true,
      transparent_background = false,
      term_colors = true,
    },
  },
  {
    -- https://github.com/navarasu/onedark.nvim
    "navarasu/onedark.nvim",
    priority = 1000, -- Ensure it loads first
    opts = {
      style = "deep", -- Default theme style. Choose between "dark", "darker", "cool", "deep", "warm", "warmer" and "light"
      transparent = true, -- Show/hide background
      term_colors = true, -- Change terminal color as per the selected theme style
      ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
      cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

      -- Options are italic, bold, underline, none
      -- You can configure multiple style with comma separated
      -- For e.g., keywords = "italic,bold"
      code_style = {
        comments = "italic",
        keywords = "none",
        functions = "none",
        strings = "none",
        variables = "none",
      },

      lualine = {
        transparent = true, -- lualine center bar transparency
      },

      -- Custom Highlights --
      colors = {}, -- Override default colors
      highlights = { -- Override highlight groups
        ["BlinkCmpGhostText"] = { fg = COLORS.bg },
        ["CurSearch"] = { fg = COLORS.purple },
        ["FloatBorder"] = { bg = "none" },
        ["FloatShadowThrough"] = { bg = "none" },
        ["Folded"] = { fg = "$light_grey" },
        ["IncSearch"] = { fg = COLORS.purple },
        ["NormalFloat"] = { bg = "none" },
        ["NvimSurroundHighlight"] = { bg = COLORS.purple },
        ["Pmenu"] = { bg = "none" },
        ["Search"] = { fg = COLORS.purple },
        ["SpellBad"] = { sp = "$fg" },
        ["SpellCap"] = { sp = "$fg" },
        ["SpellLocal"] = { sp = "$fg" },
        ["SpellRare"] = { sp = "$fg" },
        ["StatusLine"] = { bg = "none" },
      },

      -- Plugins Config --
      diagnostics = {
        darker = true, -- darker colors for diagnostic
        undercurl = true, -- use undercurl instead of underline for diagnostics
        background = true, -- use background color for virtual text
      },
    },
    config = function(_, opts)
      require("onedark").setup(opts)
      require("onedark").load()
    end,
  },
  {
    -- https://github.com/akinsho/bufferline.nvim
    "akinsho/bufferline.nvim",
    enabled = not vim.g.vscode,
    dependencies = "nvim-tree/nvim-web-devicons",
    lazy = false,
    -- stylua: ignore start
    keys = {
      { "<leader>1", function() require("bufferline").go_to(1, true) end, desc = "GoTo Ordinal Buffer 1", },
      { "<leader>2", function() require("bufferline").go_to(2, true) end, desc = "which_key_ignore", },
      { "<leader>3", function() require("bufferline").go_to(3, true) end, desc = "which_key_ignore", },
      { "<leader>4", function() require("bufferline").go_to(4, true) end, desc = "which_key_ignore", },
      { "<leader>5", function() require("bufferline").go_to(5, true) end, desc = "which_key_ignore", },
      { "<leader>6", function() require("bufferline").go_to(6, true) end, desc = "which_key_ignore", },
      { "<leader>7", function() require("bufferline").go_to(7, true) end, desc = "which_key_ignore", },
      { "<leader>8", function() require("bufferline").go_to(8, true) end, desc = "which_key_ignore", },
      { "<leader>9", function() require("bufferline").go_to(9, true) end, desc = "GoTo Ordinal Buffer 9", },
      { "<leader><", function() require("bufferline").move(-1) end,       desc = "Move buffer to the left", },
      { "<leader>>", function() require("bufferline").move(1) end,        desc = "Move buffer to the right", },
    },
    -- stylua: ignore end
    opts = {
      options = {
        truncate_names = false,
        themable = true,
        numbers = function(opts) return string.format("%s%s", opts.id, opts.raise(opts.ordinal)) end,
        diagnostics = "nvim_lsp",
        indicator = {
          icon = "█",
          style = "icon",
        },
        show_buffer_close_icons = false,
        separator_style = { "", "" },
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
      },
    },
  },
  {
    -- https://github.com/nvim-lualine/lualine.nvim
    "nvim-lualine/lualine.nvim",
    enabled = not vim.g.vscode,
    dependencies = {
      { "AndreM222/copilot-lualine" },
      { "Civitasv/cmake-tools.nvim" },
      { "lewis6991/gitsigns.nvim" },
      { "mfussenegger/nvim-dap" },
      { "nvim-tree/nvim-web-devicons" },
    },
    event = "VeryLazy",
    opts = {
      extensions = { "quickfix", "trouble", "overseer" },
      options = {
        globalstatus = true,
        component_separators = "",
        section_separators = "",
        theme = "onedark",
        refresh = {
          refresh_time = 33, -- ~30fps
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            on_click = function(n, mouse)
              if not CLICKABLE_WIDGETS then return end
              if (n == 1) and (mouse == "l") then Snacks.picker.help() end
            end,
          },
        },
        lualine_b = {
          {
            function() return present(require("cmake-tools").get_configure_preset()) end,
            icon = " ",
            cond = require("cmake-tools").is_cmake_project,
            on_click = function(n, mouse)
              if not CLICKABLE_WIDGETS then return end
              if (n == 1) and (mouse == "l") then require("cmake-tools").select_configure_preset() end
            end,
          },
          {
            function() return present(require("cmake-tools").get_build_target()) end,
            icon = " ",
            cond = require("cmake-tools").is_cmake_project,
            on_click = function(n, mouse)
              if not CLICKABLE_WIDGETS then return end
              if (n == 1) and (mouse == "l") then require("cmake-tools").select_build_target() end
            end,
          },
          {
            function() return "" end,
            cond = require("cmake-tools").is_cmake_project,
            on_click = function(n, mouse)
              if not CLICKABLE_WIDGETS then return end
              if (n == 1) and (mouse == "l") then require("cmake-tools").run() end
            end,
          },
          {
            function() return present(require("cmake-tools").get_launch_target()) end,
            cond = require("cmake-tools").is_cmake_project,
            on_click = function(n, mouse)
              if not CLICKABLE_WIDGETS then return end
              if (n == 1) and (mouse == "l") then require("cmake-tools").select_launch_target() end
            end,
          },
        },
        lualine_c = {
          {
            function() return "█" end,
            color = { fg = COLORS.blue },
            padding = { left = 0, right = 1 }, -- We don't need space before this
            on_click = function(n, mouse)
              if not CLICKABLE_WIDGETS then return end
              if (n == 1) and (mouse == "l") then Snacks.terminal.toggle() end
            end,
          },
          {
            "o:encoding",
            fmt = string.upper,
            cond = hide_in_width,
            color = { fg = COLORS.green, gui = "bold" },
            on_click = function(n, mouse)
              if not CLICKABLE_WIDGETS then return end
              if (n == 1) and (mouse == "l") then require("grug-far").open({ transient = true }) end
            end,
          },
          {
            "copilot",
            show_colors = true,
          },
          {
            function()
              local clients = vim.lsp.get_clients()
              for _, client in ipairs(clients) do
                if client.name ~= "copilot" then return "" .. client.name end
              end
              return ""
            end,
            icon = "󰡱",
            color = { fg = COLORS.white },
            on_click = function(n, mouse)
              if not CLICKABLE_WIDGETS then return end
              if (n == 1) and (mouse == "l") then require("!silent Trouble symbols") end
            end,
          },
          {
            "%=",
          },
          {
            "branch",
            icon = "",
            color = { fg = COLORS.violet, gui = "bold" },
            on_click = function(n, _mouse)
              if not CLICKABLE_WIDGETS then return end
              if n == 1 then vim.cmd("CodeDiff") end
            end,
          },
          {
            "diff",
            symbols = { added = " ", modified = "󰝤 ", removed = " " },
            diff_color = {
              added = { fg = COLORS.green },
              modified = { fg = COLORS.orange },
              removed = { fg = COLORS.red },
            },
            cond = hide_in_width,
            on_click = function(n, mouse)
              if not CLICKABLE_WIDGETS then return end
              if (n == 1) and (mouse == "l") then require("gitsigns").blame() end
            end,
          },
        },
        lualine_x = {
          {
            "filesize",
            cond = buffer_not_empty,
          },
          { "progress", color = { fg = COLORS.fg, gui = "bold" } },
          { "location" },
        },
        lualine_y = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " " },
            diagnostics_color = {
              color_error = { fg = COLORS.red },
              color_warn = { fg = COLORS.yellow },
              color_info = { fg = COLORS.cyan },
            },
            on_click = function(n, mouse)
              if not CLICKABLE_WIDGETS then return end
              if (n == 1) and (mouse == "l") then vim.cmd("!silent Trouble diagnostics toggle win.position=right") end
            end,
          },
          {
            "overseer",
            on_click = function(n, mouse)
              if not CLICKABLE_WIDGETS then return end
              if (n == 1) and (mouse == "l") then vim.cmd("!silent OverseerToggle") end
            end,
          },
        },
        lualine_z = {
          {
            "filename",
            cond = buffer_not_empty,
            color = { gui = "bold" },
            on_click = function(n, mouse)
              if not CLICKABLE_WIDGETS then return end
              if (n == 1) and (mouse == "l") then vim.cmd("!silent UndotreeToggle") end
            end,
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = { { "filesize" }, { "progress" }, { "location" }, { "filename" } },
        lualine_z = {},
      },
    },
  },
}
