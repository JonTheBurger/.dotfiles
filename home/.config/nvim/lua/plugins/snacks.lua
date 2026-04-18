---@diagnostic disable:undefined-global
local MB = 1024 * 1024
local cfg_dir = vim.fn.stdpath("config")

local downrank_undesirable_paths = function(item)
  if item.file and item.file:match("%.test") then
    item.score_mul = 0.1
  end
  if item.file and item.file:match("CMake/") then
    item.score_mul = 0.01
  end
  if item.file and item.file:match("tools") then
    item.score_mul = 0.01
  end
  if item.file and item.file:match("Test") then
    item.score_mul = 0.001
  end
  if item.file and item.file:match("ibraries") then
    item.score_mul = 0.0001
  end
  if item.file and item.file:match("xternal") then
    item.score_mul = 0.0001
  end
  if item.file and item.file:match("%.mock") then
    item.score_mul = 0.00001
  end
  if item.file and item.file:match("Mock") then
    item.score_mul = 0.000001
  end
end

return {
  {
    "folke/todo-comments.nvim",
    enabled = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    keys = {
      { "]o", function() require("todo-comments").jump_next() end, mode = { "n", }, desc = "Next TO DO Comment", },
      { "[o", function() require("todo-comments").jump_prev() end, mode = { "n", }, desc = "Previous TO DO Comment", },
      { "]2", function() require("todo-comments").jump_next() end, mode = { "n", }, desc = "Next TO DO Comment", },
      { "[2", function() require("todo-comments").jump_prev() end, mode = { "n", }, desc = "Previous TO DO Comment", },
    },
    opts = {
      highlight = {
        multiline = false,
        pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
      },
      search = {
        pattern = [[\b(KEYWORDS)(\(\w*\))*:]],
      }
    },
    init = function()
      -- To-do
      vim.keymap.set("n", "<leader>TI", function()
        vim.api.nvim_feedkeys("iTODO(POVIRK): ", "n", false)
      end, { desc = "Insert TO DO" })
      vim.keymap.set("n", "<leader>TT", function()
        vim.api.nvim_feedkeys("aTODO(POVIRK): ", "n", false)
      end, { desc = "Append TO DO" })
      vim.keymap.set("n", "<leader>T/", function()
        vim.api.nvim_feedkeys("a// TODO(POVIRK): ", "n", false)
      end, { desc = "Append / TO DO" })
      vim.keymap.set("n", "<leader>T#", function()
        vim.api.nvim_feedkeys("a# TODO(POVIRK): ", "n", false)
      end, { desc = "Append # TO DO" })
    end
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    enabled = not vim.g.vscode,
    lazy = false,
    dependencies = {
      "folke/todo-comments.nvim",
    },
    -- stylua: ignore start
    keys = {
      { "<C-\\>",          function() Snacks.terminal.toggle() end,               mode = { "n", "t", },              desc = "Toggle Terminal", },
      { "<C-F>",           function() Snacks.picker.grep({ hidden = true, transform = downrank_undesirable_paths }) end,                   desc = "Grep" },
      { "<C-p>",           function() Snacks.picker.files({ hidden = true, transform = downrank_undesirable_paths }) end, desc = "Find Files" },
      { "<C-M-p>",         function() Snacks.picker.lsp_workspace_symbols() end,  desc = "LSP Workspace Symbols" },
      { "<C-M-i>",         function() Snacks.picker.icons() end,                  desc = "Icons/Emoji",              mode = "i" },
      { "<C-S-p>",         function() Snacks.picker.commands() end,               desc = "Commands" },

      -- Top Pickers & Explorer
      { "<leader>,",       function() Snacks.picker.buffers() end,                desc = "Buffers" },
      { "<leader>/",       function() Snacks.picker.grep({transform = downrank_undesirable_paths}) end,                   desc = "Grep" },
      { "<leader>:",       function() Snacks.picker.command_history() end,        desc = "Command History" },
      { "<leader>sn",      function() Snacks.picker.notifications() end,          desc = "Notification History" },
      { "<leader>e",       function() Snacks.explorer() end,                      desc = "File Explorer" },
      -- find
      { "<leader>fb",      function() Snacks.picker.buffers() end,                desc = "Buffers" },
      { "<leader>fB",      function() require("config.fn").pickers.pick_breakpoints() end, desc = "Breakpoints" },
      { "<leader>fc",      function() Snacks.picker.files({ cwd = cfg_dir }) end, desc = "Find Config File" },
      { "<leader>ff",      function() Snacks.picker.smart({transform = downrank_undesirable_paths}) end,                desc = "Find Files" },
      { "<leader>fg",      function() Snacks.picker.git_files({transform = downrank_undesirable_paths}) end,              desc = "Find Git Files" },
      { "<leader>fp",      function() Snacks.picker.projects() end,               desc = "Projects" },
      { "<leader>fr",      function() Snacks.picker.recent() end,                 desc = "Recent" },
      -- git
      { "<leader>gB",      function() Snacks.picker.git_branches() end,           desc = "Git Branches" },
      { "<leader>gl",      function() Snacks.picker.git_log() end,                desc = "Git Log" },
      { "<leader>gL",      function() Snacks.picker.git_log_line() end,           desc = "Git Log Line" },
      { "<leader>gs",      function() Snacks.picker.git_status() end,             desc = "Git Status" },
      { "<leader>gS",      function() Snacks.picker.git_stash() end,              desc = "Git Stash" },
      { "<leader>gi",      function() Snacks.picker.git_diff() end,               desc = "Git Diff (Hunks)" },
      { "<leader>go",      function() Snacks.picker.git_log_file() end,           desc = "Git Log File" },
      -- Grep
      { "<leader>sg",
        function()
          vim.ui.input({ prompt = "Enter filetype (e.g., py, js): " }, function(input)
            if input then
              Snacks.picker.grep({ft=input, transform = downrank_undesirable_paths})
            end
          end)
        end,
        desc = "Grep by File Type"
      },
      { "<leader>sb",      function() Snacks.picker.lines() end,                  desc = "Buffer Lines" },
      { "<leader>sB",      function() Snacks.picker.grep_buffers() end,           desc = "Grep Open Buffers" },
      { "<leader>sw",      function() Snacks.picker.grep_word() end,              desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { '<leader>s"',      function() Snacks.picker.registers() end,              desc = "Registers" },
      { "<leader>s/",      function() Snacks.picker.search_history() end,         desc = "Search History" },
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
      { "<leader>st",      function () Snacks.picker.todo_comments({ keywords = { "TODO", "HACK", "WARNING", "BUG", "NOTE", "INFO", "PERF", "ERROR" } }) end, desc = "Todo Comment Tags" },
      { "<leader>sT",      function() Snacks.picker.todo_comments() end, desc = "Todo" },
      { "<leader>fC",      function() Snacks.picker.colorschemes() end,           desc = "Colorschemes" },
      -- LSP
      { "gd",              function() Snacks.picker.lsp_definitions() end,        desc = "Goto Definition" },
      { "gD",              function() Snacks.picker.lsp_declarations() end,       desc = "Goto Declaration" },
      { "gr",              function() Snacks.picker.lsp_references() end,         desc = "References",               nowait = true, },
      { "gI",              function() Snacks.picker.lsp_implementations() end,    desc = "Goto Implementation" },
      { "gy",              function() Snacks.picker.lsp_type_definitions() end,   desc = "Goto T[y]pe Definition" },
      { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,            desc = "LSP Symbols" },
      { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,  desc = "LSP Workspace Symbols" },
      { "<leader>gw",      function() Snacks.gitbrowse({ commit = vim.fn.system("git rev-parse HEAD"), }) end,   desc = "Git web view" },
    },
    -- stylua: ignore end
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      ---@class snacks.bigfile.Config
      bigfile = {
        enabled = true,
        notify = true,
        size = 1.5 * MB,
        line_length = 1000,
      },
      dashboard = {
        enabled = not vim.g.vscode,
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", pane = 2, title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", pane = 2, title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
      debug = { enabled = false },
      explorer = {
        enabled = not vim.g.vscode,
        hidden = true,
        replace_netrw = true,
        exclude = {
          ".git/*",
          ".venv/*",
        },
      },
      ---@class snacks.gitbrowse.Config
      ---@field url_patterns? table<string, table<string, string|fun(fields:snacks.gitbrowse.Fields):string>>
      gitbrowse = {
        notify = true, -- show notification on open
        ---@type "repo" | "branch" | "file" | "commit" | "permalink"
        what = "commit", -- what to open. not all remotes support all types
        url_patterns = {
          ["bitbucket%.org"] = {
            branch = "/branch/{branch}",
            file = "/commits/{commit}#chg-{file}",
            permalink = "/src/{commit}/{file}#lines-{line_start}-L{line_end}",
            commit = "/commits/{commit}#chg-{file}",
          },
        },
      },
      ---@class snacks.picker.Config
      picker = {
        enabled = not vim.g.vscode,
        debug = {
          scores = false,
        },
        -- sort = { fields = { "score:desc", "#text", "idx", }, },
        --- @param lhs snacks.picker.Item
        --- @param rhs snacks.picker.Item
        --- @return boolean
        sort = function(lhs, rhs)
          return lhs.score > rhs.score
        end,
        ui_select = true,
        -- https://github.com/folke/snacks.nvim/discussions/1798
        -- https://github.com/folke/snacks.nvim/discussions/1854
        actions = {
          open_or_pick = function(picker, item, action)
            -- 1 file open, plus 2 splits for explorer + search
            if not item.dir and #vim.api.nvim_tabpage_list_wins(0) > 3 then
              picker:action("pick_win")
              picker:action("jump")
            else
              picker:action("confirm")
            end
          end,
          jump_or_split = function(picker, item)
            local target_wins = function()
              local targets = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                local cfg = vim.api.nvim_win_get_config(win)
                if (vim.bo[buf].buflisted and cfg.relative == "") or vim.bo[buf].ft == "snacks_dashboard" then
                  local file = vim.api.nvim_buf_get_name(buf)
                  table.insert(targets, { win = win, buf = buf, file = file })
                end
              end
              return targets
            end
            local targets = target_wins()
            for _, targ in ipairs(targets) do
              if targ.file == item.file or vim.bo[targ.buf].ft == "snacks_dashboard" then
                picker.opts.jump.reuse_win = true --[[Override]]
                picker:action("jump")
                return
              end
            end
            picker:action("pick_win")
            picker:action("jump")
          end,
        },
        win = {
          input = {
            keys = {
              ["<C-c>"] = { "close", mode = { "n" } },
            },
          },
          list = {
            -- stylua: ignore start
            keys = {
              ["<Esc>"] = "", -- Do not close explorer on ESC
              ["<CR>"] = { "open_or_pick", mode = { "n", "i" } },
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
            layout = {
              auto_hide = {"input"},
            },
            win = {
              list = {
                keys = {
                  ["/"] = false,
                  ["<c-c>"] = false,
                  ["<c-f>"] = "toggle_focus",
                  ["C"] = "tcd", -- tab change dir
                  ['<C-w>w'] = { '<cmd>wincmd 2w<CR>', expr = true },
                },
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
          history_bonus = false,
        },
      },
      image = {
        enabled = not vim.g.vscode,
        markdown = {
          float = true,
        },
      },
      input = { enabled = not vim.g.vscode },
      quickfile = { enabled = true },
      scroll = { enabled = not vim.g.vscode },
      ---@diagnostic disable-next-line missing-fields
      statuscolumn = {
        enabled = not vim.g.vscode,
        left = { "mark", "sign" },
        right = { "fold", "git" },
        folds = { open = true },
      },
      terminal = { enabled = not vim.g.vscode },
      notifier = { enabled = not vim.g.vscode },
      rename = { enabled = not vim.g.vscode },
      win = { enabled = not vim.g.vscode },
      styles = {
        -- Disable ugly header on toggle terminal
        terminal = { wo = { winbar = "" } },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd

          vim.g.snacks_animate = false
          vim.keymap.set("n", "z=", function() Snacks.picker.spelling() end, { desc = "Spelling" })

          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>os")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceil" }):map("<leader>oc")
          Snacks.toggle.diagnostics({ name = "Diagnostics" }):map("<leader>od")
          Snacks.toggle.treesitter():map("<leader>ot")
          -- Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>og")
          Snacks.toggle.inlay_hints():map("<leader>oh")
          Snacks.toggle.dim():map("<leader>oi")
          Snacks.toggle.option("list", { name = "Visible Whitespace" }):map("<leader>o ")
          Snacks.toggle.option("wrap", { name = "Wrap Long Lines" }):map("<leader>ow")
          Snacks.toggle.indent():map("<leader>oz")
          Snacks.toggle.new({
            id = "virtual text",
            name = "DAP Virtual Text Toggle",
            get = function()
              return true
            end,
            set = function(state)
              require("dap-view").virtual_text_toggle()
            end,
          }):map("<leader>ov")
          Snacks.toggle.new({
            id = "git blame",
            name = "Git Blame",
            get = function()
              return require("gitsigns.config").config.current_line_blame
            end,
            set = function(state)
              require("gitsigns").toggle_current_line_blame(state)
            end,
          }):map("<leader>ob")
          Snacks.toggle.new({
            id = "animate",
            name = "Animate",
            get = function()
              return vim.g.snacks_animate == true
            end,
            set = function(state)
              if state then
                vim.g.snacks_animate = true
                require("smear_cursor").enabled = true
              else
                vim.g.snacks_animate = false
                require("smear_cursor").enabled = false
              end
            end,
          }):map("<leader>oa")
          Snacks.toggle.new({
            id = "theme",
            name = "Light Theme",
            get = function()
              return vim.g.colors_name ~= "onedark"
            end,
            set = function(state)
              if state then
                vim.cmd.colorscheme("catppuccin-latte")
              else
                vim.cmd.colorscheme("onedark")
              end
            end,
          }):map("<leader>ol")
          Snacks.toggle.new({
            id = "markdown",
            name = "Markdown Preview",
            get = function() return require("render-markdown").get() end,
            set = function(state)
              if state then
                require("render-markdown").enable()
              else
                require("render-markdown").disable()
              end
            end,
          }):map("<leader>om")
        end,
      })
    end,
  },
}
