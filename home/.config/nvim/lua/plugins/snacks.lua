---@diagnostic disable:undefined-global
local MB = 1024 * 1024
local cfg_dir = vim.fn.stdpath("config")

return {
  "folke/snacks.nvim",
  priority = 1000,
  enabled = true,
  lazy = false,
  -- stylua: ignore start
  keys = {
    { "<C-\\>",          function() Snacks.terminal.toggle() end,               mode = { "n", "t", },              desc = "Toggle Terminal", },
    { "<C-F>",           function() Snacks.picker.grep() end,                   desc = "Grep" },
    { "<C-S-p>",         function() Snacks.picker.commands() end,               desc = "Commands" },
    { "<C-p>",           function() Snacks.picker.files({ hidden = true }) end, desc = "Find Files" },
    { "<C-M-p>",         function() Snacks.picker.lsp_workspace_symbols() end,  desc = "LSP Workspace Symbols" },
    { "<C-M-i>",         function() Snacks.picker.icons() end,                  desc = "Icons/Emoji",              mode = "i" },
    { "<leader>Wg",      function() Snacks.lazygit.open() end,                  desc = "LazyGit" },

    -- Top Pickers & Explorer
    { "<leader><space>", function() Snacks.picker.smart() end,                  desc = "Smart Find Files" },
    { "<leader>,",       function() Snacks.picker.buffers() end,                desc = "Buffers" },
    { "<leader>/",       function() Snacks.picker.grep() end,                   desc = "Grep" },
    { "<leader>:",       function() Snacks.picker.command_history() end,        desc = "Command History" },
    { "<leader>n",       function() Snacks.picker.notifications() end,          desc = "Notification History" },
    { "<leader>e",       function() Snacks.explorer() end,                      desc = "File Explorer" },
    -- find
    { "<leader>fb",      function() Snacks.picker.buffers() end,                desc = "Buffers" },
    { "<leader>fc",      function() Snacks.picker.files({ cwd = cfg_dir }) end, desc = "Find Config File" },
    { "<leader>ff",      function() Snacks.picker.files() end,                  desc = "Find Files" },
    { "<leader>fg",      function() Snacks.picker.git_files() end,              desc = "Find Git Files" },
    { "<leader>fp",      function() Snacks.picker.projects() end,               desc = "Projects" },
    { "<leader>fr",      function() Snacks.picker.recent() end,                 desc = "Recent" },
    -- git
    { "<leader>gb",      function() Snacks.picker.git_branches() end,           desc = "Git Branches" },
    { "<leader>gl",      function() Snacks.picker.git_log() end,                desc = "Git Log" },
    { "<leader>gL",      function() Snacks.picker.git_log_line() end,           desc = "Git Log Line" },
    { "<leader>gs",      function() Snacks.picker.git_status() end,             desc = "Git Status" },
    { "<leader>gS",      function() Snacks.picker.git_stash() end,              desc = "Git Stash" },
    { "<leader>gd",      function() Snacks.picker.git_diff() end,               desc = "Git Diff (Hunks)" },
    { "<leader>gf",      function() Snacks.picker.git_log_file() end,           desc = "Git Log File" },
    -- Grep
    { "<leader>sb",      function() Snacks.picker.lines() end,                  desc = "Buffer Lines" },
    { "<leader>sB",      function() Snacks.picker.grep_buffers() end,           desc = "Grep Open Buffers" },
    { "<leader>sg",      function() Snacks.picker.grep() end,                   desc = "Grep" },
    { "<leader>sw",      function() Snacks.picker.grep_word() end,              desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { '<leader>s"',      function() Snacks.picker.registers() end,              desc = "Registers" },
    { '<leader>s/',      function() Snacks.picker.search_history() end,         desc = "Search History" },
    { "<leader>sa",      function() Snacks.picker.autocmds() end,               desc = "Autocmds" },
    { "<leader>sb",      function() Snacks.picker.lines() end,                  desc = "Buffer Lines" },
    { "<leader>sc",      function() Snacks.picker.command_history() end,        desc = "Command History" },
    { "<leader>sC",      function() Snacks.picker.commands() end,               desc = "Commands" },
    { "<leader>sd",      function() Snacks.picker.diagnostics() end,            desc = "Diagnostics" },
    { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,     desc = "Buffer Diagnostics" },
    { "<leader>sh",      function() Snacks.picker.help() end,                   desc = "Help Pages" },
    { "<leader>sH",      function() Snacks.picker.highlights() end,             desc = "Highlights" },
    { "<leader>si",      function() Snacks.picker.icons() end,                  desc = "Icons" },
    { "<leader>sj",      function() Snacks.picker.jumps() end,                  desc = "Jumps" },
    { "<leader>sk",      function() Snacks.picker.keymaps() end,                desc = "Keymaps" },
    { "<leader>sl",      function() Snacks.picker.loclist() end,                desc = "Location List" },
    { "<leader>sm",      function() Snacks.picker.marks() end,                  desc = "Marks" },
    { "<leader>sM",      function() Snacks.picker.man() end,                    desc = "Man Pages" },
    { "<leader>sp",      function() Snacks.picker.lazy() end,                   desc = "Search for Plugin Spec" },
    { "<leader>sq",      function() Snacks.picker.qflist() end,                 desc = "Quickfix List" },
    { "<leader>sR",      function() Snacks.picker.resume() end,                 desc = "Resume" },
    { "<leader>su",      function() Snacks.picker.undo() end,                   desc = "Undo History" },
    { "<leader>uC",      function() Snacks.picker.colorschemes() end,           desc = "Colorschemes" },
    -- LSP
    { "gd",              function() Snacks.picker.lsp_definitions() end,        desc = "Goto Definition" },
    { "gD",              function() Snacks.picker.lsp_declarations() end,       desc = "Goto Declaration" },
    { "gr",              function() Snacks.picker.lsp_references() end,         desc = "References",               nowait = true, },
    { "gI",              function() Snacks.picker.lsp_implementations() end,    desc = "Goto Implementation" },
    { "gy",              function() Snacks.picker.lsp_type_definitions() end,   desc = "Goto T[y]pe Definition" },
    { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,            desc = "LSP Symbols" },
    { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,  desc = "LSP Workspace Symbols" },
  },
  -- stylua: ignore end
  ---@type snacks.Config
  opts = {
    ---@class snacks.bigfile.Config
    bigfile = {
      enable = true,
      notify = true,
      size = 1.5 * MB,
      line_length = 1000,
    },
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        { icon = " ", pane = 2, title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { icon = " ", pane = 2, title = "Projects", section = "projects", indent = 2, padding = 1 },
        { section = "startup" },
      },
    },
    debug = { enabled = true },
    explorer = {
      enabled = true,
      hidden = true,
      replace_netrw = true,
      exclude = {
        ".git/*",
        ".venv/*",
      }
    },
    ---@class snacks.picker.Config
    picker = {
      enabled = true,
      ui_select = true,
      win = {
        list = {
          -- stylua: ignore start
          keys = {
            ["<Esc>"] = "", -- Do not close explorer on ESC
            ["<CR>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
            ["<C-h>"] = { "<C-h>", function(_) vim.cmd("wincmd h") end, desc = "Do not break C-h to move to the window on the right", },
            ["<C-j>"] = { "<C-j>", function(_) vim.cmd("wincmd j") end, desc = "Do not break C-j to move to the window on the right", },
            ["<C-k>"] = { "<C-k>", function(_) vim.cmd("wincmd k") end, desc = "Do not break C-k to move to the window on the right", },
            ["<C-l>"] = { "<C-l>", function(_) vim.cmd("wincmd l") end, desc = "Do not break C-l to move to the window on the right", },
          },
          -- stylua: ignore end
        },
      },
      sources = {
        explorer = {
          hidden = true,
          win = {
            list = {
              ---@class snacks.win.Config
              wo = {
                number = true,
                relativenumber = true,
              },
            }
          },
        },
      },
      matcher = {
        frecency = true,
      },
    },
    image = {
      enabled = true,
      markdown = {
        float = true,
      },
    },
    input = { enabled = true },
    lazygit = { enabled = true },
    quickfile = { enabled = true },
    ---@diagnostic disable-next-line missing-fields
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" },
      right = { "fold", "git" },
      folds = { open = true },
    },
    terminal = { enabled = true, },
    notifier = { enabled = true },
    rename = { enabled = true },
    win = { enabled = true },
    styles = {
      -- Disable ugly header on toggle terminal
      terminal = { wo = { winbar = "" } },
    },
  },
  init = function()
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
    _G.bt = function()
      Snacks.debug.backtrace()
    end
    vim.print = _G.dd
    vim.api.nvim_create_user_command("Colorize", function()
      Snacks.terminal.colorize()
    end, {})
  end,
}
