-- vim.api.nvim_get_hl(0, {name="WinSeparator"})
local colors = {
  bg = "#455574",
  fg = "#bbc2cf",
  red = "#ec5f67",
  orange = "#ff8800",
  yellow = "#ecbe7b",
  green = "#4ef278",
  blue = "#51afef",
  cyan = "#0084ff",
  violet = "#c489ff",
  magenta = "#ff539e",
  white = "#cccccc",
  dark_grey = "#20303b",
  brown = "#885a2c",
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
  is_cmake_project = function()
    local cmake = require("cmake-tools")
    return cmake.is_cmake_project() and cmake.has_cmake_preset()
  end,
}

local function cmake_line()
  local cmake_presets = io.open(vim.fn.getcwd() .. "/CMakePresets.json", "r")
  if cmake_presets == nil then
    return {}
  end
  io.close(cmake_presets)
  local present = function(text)
    return "[" .. (text and text or "?") .. "]"
  end
  local cmake = require("cmake-tools")

  return {
    {
      function()
        return present(cmake.get_configure_preset())
      end,
      icon = " ",
      cond = conditions.is_cmake_project,
      on_click = function(n, mouse)
        if (n == 1) and (mouse == "l") then
          cmake.select_configure_preset()
        end
      end,
    },
    {
      function()
        return present(cmake.get_build_target())
      end,
      icon = " ",
      cond = cmake.is_cmake_project,
      on_click = function(n, mouse)
        if (n == 1) and (mouse == "l") then
          cmake.select_build_target()
        end
      end,
    },
    {
      function()
        return ""
      end,
      cond = cmake.is_cmake_project,
      on_click = function(n, mouse)
        if (n == 1) and (mouse == "l") then
          cmake.run()
        end
      end,
    },
    {
      function()
        return present(cmake.get_launch_target())
      end,
      cond = cmake.is_cmake_project,
      on_click = function(n, mouse)
        if (n == 1) and (mouse == "l") then
          cmake.select_launch_target()
        end
      end,
    },
  }
end

return {
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      enabled = false,
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
        ["@comment.todo"] = { fmt = "bold" },
        ["BlinkCmpGhostText"] = { fg = colors.bg },
        ["DiffviewDiffDelete"] = { fg = colors.dark_grey },
        ["FloatBorder"] = { bg = "none" },
        ["Folded"] = { fg = "$light_grey" },
        ["NormalFloat"] = { bg = "none" },
        ["NvimSurroundHighlight"] = { bg = colors.brown },
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
    init = function()
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "⚑",
            [vim.diagnostic.severity.INFO] = "",
          },
          linehl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
          },
        },
        virtual_lines = false,
        virtual_text = true,
      })
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "🯄", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "ⓧ", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "✎", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticSignWarn", linehl = "DiagnosticSignError", numhl = "DiagnosticSignError" })
    end,
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
      { "<leader>2", function() require("bufferline").go_to(2, true) end, desc = "GoTo Ordinal Buffer 2", },
      { "<leader>3", function() require("bufferline").go_to(3, true) end, desc = "GoTo Ordinal Buffer 3", },
      { "<leader>4", function() require("bufferline").go_to(4, true) end, desc = "GoTo Ordinal Buffer 4", },
      { "<leader>5", function() require("bufferline").go_to(5, true) end, desc = "GoTo Ordinal Buffer 5", },
      { "<leader>6", function() require("bufferline").go_to(6, true) end, desc = "GoTo Ordinal Buffer 6", },
      { "<leader>7", function() require("bufferline").go_to(7, true) end, desc = "GoTo Ordinal Buffer 7", },
      { "<leader>8", function() require("bufferline").go_to(8, true) end, desc = "GoTo Ordinal Buffer 8", },
      { "<leader>9", function() require("bufferline").go_to(9, true) end, desc = "GoTo Ordinal Buffer 9", },
      { "<leader><", function() require("bufferline").move(-1) end,       desc = "Move buffer to the left", },
      { "<leader>>", function() require("bufferline").move(1) end,        desc = "Move buffer to the right", },
    },
    -- stylua: ignore end
    opts = {
      options = {
        truncate_names = false,
        themable = true,
        numbers = function(opts)
          return string.format("%s%s", opts.id, opts.raise(opts.ordinal))
        end,
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
      { "MagicDuck/grug-far.nvim" },
      { "hedyhli/outline.nvim" },
      { "lewis6991/gitsigns.nvim" },
      { "mbbill/undotree" },
      { "mfussenegger/nvim-dap" },
      { "nvim-tree/nvim-web-devicons" },
      { "zbirenbaum/copilot.lua" },
    },
    event = "VeryLazy",
    init = function()
      vim.opt.fillchars:append({
        stl = "─",
        stlnc = "─",
      })
    end,
    opts = {
      extensions = { "quickfix", "trouble", "overseer" },
      options = {
        component_separators = "",
        section_separators = "",
        theme = "onedark",
      },
      sections = {
        lualine_a = {
          {
            "mode",
            on_click = function(n, mouse)
              if (n == 1) and (mouse == "l") then
                Snacks.picker.help()
              end
            end,
          },
        },
        lualine_b = cmake_line(),
        lualine_c = {
          {
            function()
              return "█"
            end,
            color = { fg = colors.blue },
            padding = { left = 0, right = 1 }, -- We don't need space before this
            on_click = function(n, mouse)
              if (n == 1) and (mouse == "l") then
                Snacks.terminal.toggle()
              end
            end,
          },
          {
            "o:encoding",
            fmt = string.upper,
            cond = conditions.hide_in_width,
            color = { fg = colors.green, gui = "bold" },
            on_click = function(n, mouse)
              if (n == 1) and (mouse == "l") then
                require("grug-far").open({ transient = true })
              end
            end,
          },
          {
            function()
              local msg = ""
              local clients = vim.lsp.get_clients()
              if next(clients) == nil then
                return msg
              end
              local ftype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
              for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, ftype) ~= -1 then
                  return client.name
                end
              end
              return msg
            end,
            icon = "󰡱",
            color = { fg = colors.white },
            on_click = function(n, mouse)
              if (n == 1) and (mouse == "l") then
                require("outline").open()
              end
            end,
          },
          {
            "copilot",
            show_colors = true,
          },
          {
            "%=",
          },
          {
            "branch",
            icon = "",
            color = { fg = colors.violet, gui = "bold" },
            on_click = function(n, mouse)
              if (n == 1) and (mouse == "l") then
                vim.cmd("DiffviewOpen")
              elseif (n == 1) and (mouse == "r") then
                vim.cmd("DiffviewClose")
              end
            end,
          },
          {
            "diff",
            symbols = { added = " ", modified = "󰝤 ", removed = " " },
            diff_color = {
              added = { fg = colors.green },
              modified = { fg = colors.orange },
              removed = { fg = colors.red },
            },
            cond = conditions.hide_in_width,
            on_click = function(n, mouse)
              if (n == 1) and (mouse == "l") then
                require("gitsigns").blame()
              end
            end,
          },
        },
        lualine_x = {
          {
            "filesize",
            cond = conditions.buffer_not_empty,
          },
          { "progress", color = { fg = colors.fg, gui = "bold" } },
          { "location" },
        },
        lualine_y = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " " },
            diagnostics_color = {
              color_error = { fg = colors.red },
              color_warn = { fg = colors.yellow },
              color_info = { fg = colors.cyan },
            },
            on_click = function(n, mouse)
              if (n == 1) and (mouse == "l") then
                vim.cmd("Trouble diagnostics toggle win.position=right")
              end
            end,
          },
          {
            "overseer",
            on_click = function(n, mouse)
              if (n == 1) and (mouse == "l") then
                vim.cmd("OverseerToggle")
              end
            end,
          },
        },
        lualine_z = {
          {
            "filename",
            cond = conditions.buffer_not_empty,
            color = { gui = "bold" },
            on_click = function(n, mouse)
              if (n == 1) and (mouse == "l") then
                vim.cmd("UndotreeToggle")
              end
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
