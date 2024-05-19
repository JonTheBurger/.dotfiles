-- https://github.com/nvim-lualine/lualine.nvim
local colors = {
  bg       = "#202328",
  fg       = "#bbc2cf",
  yellow   = "#ecbe7b",
  cyan     = "#0084ff",
  darkblue = "#081633",
  green    = "#4ef278",
  orange   = "#ff8800",
  violet   = "#c489ff",
  magenta  = "#ff539e",
  blue     = "#51afef",
  red      = "#ec5f67",
  white    = "#cccccc",
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
}

local function cmake()
  local cmake_presets = io.open(vim.fn.getcwd() .. "/CMakePresets.json", "r")

  if cmake_presets ~= nil then
    io.close(cmake_presets)
    local cmake = require("cmake-tools")
    cmake.setup({})

    return {
      {
        function()
          local c_preset = cmake.get_configure_preset()
          return "[" .. (c_preset and c_preset or "CONFIG") .. "]"
        end,
        icon = "",
        cond = function()
          return cmake.is_cmake_project() and cmake.has_cmake_preset()
        end,
        on_click = function(n, mouse)
          if (n == 1) then
            if (mouse == "l") then
              vim.cmd("CMakeSelectConfigurePreset")
            end
          end
        end
      },
      {
        function()
          local b_target = cmake.get_build_target()
          return "[" .. (b_target and b_target or "BUILD") .. "]"
        end,
        icon = "⚙",
        cond = cmake.is_cmake_project,
        on_click = function(n, mouse)
          if (n == 1) then
            if (mouse == "l") then
              vim.cmd("CMakeSelectBuildTarget")
            end
          end
        end
      },
      {
        function()
          return "▹"
        end,
        cond = cmake.is_cmake_project,
        on_click = function(n, mouse)
          if (n == 1) then
            if (mouse == "l") then
              vim.cmd("CMakeRun")
            end
          end
        end
      },
      {
        function()
          local l_target = cmake.get_launch_target()
          return "[" .. (l_target and l_target or "LAUNCH") .. "]"
        end,
        cond = cmake.is_cmake_project,
        on_click = function(n, mouse)
          if (n == 1) then
            if (mouse == "l") then
              vim.cmd("CMakeSelectLaunchTarget")
            end
          end
        end
      },
    }
  end
  return {}
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
    { "Civitasv/cmake-tools.nvim" },
    { "mfussenegger/nvim-dap", },
    { "VonHeikemen/lsp-zero.nvim", },
  },
  event = "VeryLazy",
  config = function()
    require("lualine").setup({
      options = {
        component_separators = "",
        section_separators = "",
        theme = "powerline_dark",
      },
      sections = {
        -- these are to remove the defaults
        lualine_a = {"mode"},
        lualine_b = cmake(),
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {
          {
            function()
              return "▊"
            end,
            color = { fg = colors.blue },
            padding = { left = 0, right = 1 }, -- We don"t need space before this
          },
          {
            -- mode component
            function()
              return ""
            end,
            color = function()
              local mode_color = {
                n = colors.red,
                i = colors.green,
                v = colors.blue,
                [""] = colors.blue,
                V = colors.blue,
                c = colors.magenta,
                no = colors.red,
                s = colors.orange,
                S = colors.orange,
                [""] = colors.orange,
                ic = colors.yellow,
                R = colors.violet,
                Rv = colors.violet,
                cv = colors.red,
                ce = colors.red,
                r = colors.cyan,
                rm = colors.cyan,
                ["r?"] = colors.cyan,
                ["!"] = colors.red,
                t = colors.red,
              }
              return { fg = mode_color[vim.fn.mode()] }
            end,
            padding = { right = 1 },
          },
          {
            "o:encoding",
            fmt = string.upper,
            cond = conditions.hide_in_width,
            color = { fg = colors.green, gui = "bold" },
          },
          {
            "fileformat",
            fmt = string.upper,
            icons_enabled = false,
            color = { fg = colors.green, gui = "bold" },
          },
          {
            -- Lsp server name .
            function()
              local msg = "<LSP>"
              local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
              local clients = vim.lsp.get_active_clients()
              if next(clients) == nil then
                return msg
              end
              for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                  return client.name
                end
              end
              return msg
            end,
            icon = "",
            color = { fg = colors.white },
          },
          -- MIDDLE --
          {
            function()
              return "%="
            end,
          },
          {
            "branch",
            icon = "",
            color = { fg = colors.violet, gui = "bold" },
            on_click = function(n, mouse)
              if (n == 1) then
                if (mouse == "l") then
                  require("lazygit")
                  vim.cmd("LazyGit")
                end
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
          },
        },
        lualine_x = {
          {
            "filesize",
            cond = conditions.buffer_not_empty,
          },
          { "progress", color = { fg = colors.fg, gui = "bold" } },
          { "location" },
          {
            "filename",
            cond = conditions.buffer_not_empty,
            color = { fg = colors.violet, gui = "bold" },
          },
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
              if (n == 1) then
                if (mouse == "l") then
                  vim.cmd("Trouble")
                end
              end
            end,
          },
        },
      },
      inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
    })
  end,
}
