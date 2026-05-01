---@module "lazy"
---@type LazyPluginSpec[]
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    enabled = not vim.g.vscode,
    lazy = false,
    dependencies = {
      "folke/todo-comments.nvim",
    },
    keys = {
      -- stylua: ignore start
      { "<C-p>",   function() Snacks.picker.files() end,                          desc = "Find Files" },
      { "<C-f>",   function() Snacks.picker.grep() end,                           desc = "Grep" },
      { "<C-A-p>", function() Snacks.picker.lsp_workspace_symbols() end,          desc = "LSP Workspace Symbols" },
      { "<C-S-p>", function() Snacks.picker.commands() end,                       desc = "Commands" },
      { "<C-A-i>", function() Snacks.picker.icons() end, mode = "i",              desc = "Icons/Emoji" },
      { "<C-\\>",  function() Snacks.terminal.toggle() end, mode = { "n", "t", }, desc = "Toggle Terminal", },
      { "<A-\\>",  function() Snacks.terminal.toggle(nil, { win = { position = "float", border = "rounded" } }) end, mode = { "n", "t", }, desc = "Float Terminal", },
      -- Top Pickers & Explorer
      { "<leader>,",  function() Snacks.picker.buffers() end,         desc = "Buffers" },
      { "<leader>:",  function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sn", function() Snacks.picker.notifications() end,   desc = "Notification History" },
      { "<leader>e",  function() Snacks.explorer() end,               desc = "File Explorer" },
      -- find
      { "<leader>fc",    function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff",    function() Snacks.picker.smart() end,                   desc = "Find Files" },
      { "<leader>fg",    function() Snacks.picker.git_files() end,               desc = "Git Find Files" },
      { "<leader>fb",    function() Snacks.picker.buffers() end,                 desc = "Buffers" },
      { "<leader>fp",    function() Snacks.picker.projects() end,                desc = "Projects" },
      { "<leader>fr",    function() Snacks.picker.recent() end,                  desc = "Recent" },
      { "<leader>fB",    function() require("config.fn").pick.breakpoints() end, desc = "Breakpoints" },
      { "<leader>f<F9>", function() require("config.fn").pick.breakpoints() end, desc = "Breakpoints" },
      -- git
      { "<leader>gB", function() Snacks.picker.git_branches() end, desc = "Git Pick Branche" },
      { "<leader>gl", function() Snacks.picker.git_log() end,      desc = "Git Pick Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Pick Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end,   desc = "Git Pick Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end,    desc = "Git Pick Stash" },
      { "<leader>gi", function() Snacks.picker.git_diff() end,     desc = "Git Pick Diff (Hunks)" },
      { "<leader>go", function() Snacks.picker.git_log_file() end, desc = "Git Pick Log File" },
      { "<leader>hb", function() Snacks.git.blame_line() end,      desc = "Git Blame Hover" },
      ---@diagnostic disable-next-line: missing-fields,param-type-mismatch
      { "<leader>gw", function() Snacks.gitbrowse({ commit = vim.fn.system("git rev-parse HEAD"), }) end, desc = "Git web view" },
      -- Grep
      { "<leader>sg", function() vim.ui.input({ prompt = "Enter filetype (e.g., cpp, py): " }, function(input) if input then Snacks.picker.grep({ ft = input }) end end) end, desc = "Grep by File Type" },
      { "<leader>sb", function() Snacks.picker.lines() end,                  desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end,           desc = "Grep Open Buffers" },
      { "<leader>sw", function() Snacks.picker.grep_word() end,              desc = "Visual selection or word", mode = { "n", "x" } },
      -- Search
      { '<leader>s"', function() Snacks.picker.registers() end,              desc = "Registers" },
      { "<leader>s/", function() Snacks.picker.search_history() end,         desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end,               desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines() end,                  desc = "Buffer Lines" },
      { "<leader>sc", function() Snacks.picker.command_history() end,        desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end,               desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end,            desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end,     desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end,                   desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end,             desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end,                  desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end,                  desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end,                desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end,                desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end,                  desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man() end,                    desc = "Man Pages" },
      { "<leader>sp", function() Snacks.picker.lazy() end,                   desc = "Search for Plugin Spec" },
      { "<leader>sq", function() Snacks.picker.qflist() end,                 desc = "Quickfix List" },
      { "<leader>sR", function() Snacks.picker.resume() end,                 desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end,                   desc = "Undo History" },
      { "<leader>fC", function() Snacks.picker.colorschemes() end,           desc = "Colorschemes" },
      -- LSP
      { "gd",         function() Snacks.picker.lsp_definitions() end,        desc = "Goto Definition" },
      { "gD",         function() Snacks.picker.lsp_declarations() end,       desc = "Goto Declaration" },
      { "gr",         function() Snacks.picker.lsp_references() end,         desc = "References",               nowait = true, },
      { "gI",         function() Snacks.picker.lsp_implementations() end,    desc = "Goto Implementation" },
      { "gy",         function() Snacks.picker.lsp_type_definitions() end,   desc = "Goto T[y]pe Definition" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end,            desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end,  desc = "LSP Workspace Symbols" },
      -- Extras
      ---@diagnostic disable-next-line: undefined-field
      { "<leader>f2", function() Snacks.picker.todo_comments() end, desc = "To Do Comments" },
      { "<leader>z",  function() Snacks.zen.zoom() end,             desc = "Zoom Window" },
      { "<leader>Z",  function() Snacks.zen.zen() end,              desc = "Zen Mode" },
      { "z=",         function() Snacks.picker.spelling() end,      desc = "Fix Spelling" },
      -- stylua: ignore end
    },
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      ---@type snacks.bigfile.Config
      ---@diagnostic disable-next-line: missing-fields
      bigfile = {
        enabled = true,
        notify = true,
        size = 1.5 * 1024 * 1024,
        line_length = 1000,
      },
      ---@type snacks.dashboard.Config
      ---@diagnostic disable-next-line: missing-fields
      dashboard = {
        enabled = not vim.g.vscode,
        preset = {
          keys = {
            { icon = "", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = "", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = "", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = "", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = "",
              key = "c",
              desc = "Config",
              action = function()
                vim.fn.chdir(vim.fn.expand("~/.dotfiles/home/.config/nvim"))
                vim.schedule(function()
                  require("persistence").load({ last = true })
                  vim.fn.chdir(vim.fn.expand("~/.dotfiles/home/.config/nvim"))
                end)
              end,
            },
            { icon = "", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = "", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", pane = 2, title = "Projects", section = "projects", indent = 2, padding = 1, limit = 10 },
          { section = "startup" },
        },
      },
      ---@type snacks.explorer.Config
      explorer = {
        enabled = not vim.g.vscode,
        trash = true,
        hidden = true,
        replace_netrw = true,
        exclude = {
          ".git/*",
          ".venv/*",
          "node_modules/*",
        },
      },
      ---@type snacks.gitbrowse.Config
      ---@diagnostic disable-next-line: missing-fields
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
      ---@type snacks.picker.Config
      picker = {
        enabled = not vim.g.vscode,
        transform = function(item)
          if not item.file then return end
          local factor = 1.0
          for _, pattern in ipairs(require("config.prefs").uninteresting_patterns) do
            if item.file:lower():match(pattern) then
              factor = factor * 0.3
              item.score_mul = factor
            end
          end
          for _, pattern in ipairs(require("config.prefs").ignore_patterns) do
            if item.file:lower():match(pattern) then
              factor = factor * 0.05
              item.score_mul = factor
            end
          end
        end,
        debug = {
          scores = false,
        },
        -- sort = { fields = { "score:desc", "#text", "idx", }, },
        --- @param lhs snacks.picker.Item
        --- @param rhs snacks.picker.Item
        --- @return boolean
        sort = function(lhs, rhs) return lhs.score > rhs.score end,
        ui_select = true,
        -- https://github.com/folke/snacks.nvim/discussions/1798
        -- https://github.com/folke/snacks.nvim/discussions/1854
        actions = {
          open_or_pick = function(picker, item, _action)
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
          grep = {
            hidden = true,
          },
          files = {
            hidden = true,
          },
          explorer = {
            hidden = true,
            layout = {
              auto_hide = { "input" },
            },
            win = {
              list = {
                keys = {
                  ["/"] = false,
                  ["<C-c>"] = false,
                  ["<C-f>"] = "toggle_focus",
                  ["C"] = "tcd", -- tab change dir
                  ["<C-w>w"] = { "<cmd>wincmd 2w<CR>", expr = true },
                },
                ---@type snacks.win.Config
                ---@diagnostic disable-next-line: missing-fields
                wo = {
                  number = true,
                  relativenumber = true,
                },
              },
            },
          },
        },
        matcher = {
          frecency = jit.os ~= "Windows",
          history_bonus = false,
        },
      },
      ---@type snacks.image.Config
      ---@diagnostic disable-next-line: missing-fields
      image = {
        enabled = not vim.g.vscode,
        markdown = {
          float = true,
        },
      },
      ---@type snacks.input.Config
      ---@diagnostic disable-next-line: missing-fields
      input = { enabled = not vim.g.vscode },
      ---@type snacks.quickfile.Config
      ---@diagnostic disable-next-line: missing-fields
      quickfile = { enabled = true },
      ---@type snacks.scroll.Config
      ---@diagnostic disable-next-line: missing-fields
      scroll = {
        enabled = not vim.g.vscode,
        animate = {
          fps = 120,
          duration = {
            step = 2,
            total = 30,
          },
        },
        animate_repeat = {
          delay = 1,
          max = 1,
        },
      },
      ---@type snacks.statuscolumn.Config
      ---@diagnostic disable-next-line missing-fields
      statuscolumn = {
        enabled = not vim.g.vscode,
        left = { "mark", "sign" },
        right = { "fold", "git" },
        folds = { open = true },
        refresh = 100,
      },
      ---@type snacks.scope.Config
      ---@diagnostic disable-next-line: missing-fields
      scope = {
        min_size = 2,
        cursor = true,
        siblings = true, -- expand single line scopes with single line siblings
        treesitter = {
          enabled = true,
        },
        keys = {
          ---@type table<string, snacks.scope.TextObject|{desc?:string}|false>
          textobject = {
            ii = false,
            ai = false,
            io = {
              cursor = true,
              min_size = 2, -- minimum size of the scope
              edge = false, -- inner scope
              treesitter = { blocks = { enabled = true } },
              desc = "inner scope",
            },
            ao = {
              cursor = true,
              min_size = 2, -- minimum size of the scope
              treesitter = { blocks = { enabled = true } },
              desc = "full scope",
            },
          },
          ---@type table<string, snacks.scope.Jump|{desc?:string}|false>
          jump = {
            ["[i"] = false,
            ["]i"] = false,
            ["]o"] = {
              bottom = true,
              cursor = true,
              edge = true,
              treesitter = { blocks = { enabled = true } },
              desc = "Jump to top of scope",
            },
            ["[o"] = {
              bottom = false,
              cursor = true,
              edge = true,
              treesitter = { blocks = { enabled = true } },
              desc = "Jump to bottom of scope",
            },
          },
        },
      },
      ---@type snacks.indent.Config
      ---@diagnostic disable-next-line: missing-fields
      indent = {
        enabled = not vim.g.vscode,
        indent = { enabled = false },
        scope = { enabled = false },
        chunk = {
          enabled = true,
          hl = "@comment",
          char = {
            vertical = "╎",
          },
        },
        ---@type snacks.indent.animate
        ---@diagnostic disable-next-line: missing-fields
        animate = {
          enabled = true,
          duration = {
            step = 50,
          },
        },
      },
      ---@type snacks.terminal.Config
      terminal = { enabled = not vim.g.vscode },
      ---@type snacks.notifier.Config
      ---@diagnostic disable-next-line: missing-fields
      notifier = { enabled = not vim.g.vscode },
      ---@type snacks.win.Config
      ---@diagnostic disable-next-line: missing-fields
      win = { enabled = not vim.g.vscode },
      styles = {
        -- Disable ugly header on toggle terminal
        terminal = { wo = { winbar = "" } },
      },
      ---@type snacks.zen.Config
      ---@diagnostic disable-next-line: missing-fields
      zen = { enabled = true },
    },
    init = function()
      ---@diagnostic disable-next-line: global-in-non-module
      _G.dd = function(...) Snacks.debug.inspect(...) end
      ---@diagnostic disable-next-line: global-in-non-module
      _G.bt = function() Snacks.debug.backtrace() end
      vim.print = _G.dd

      vim.g.snacks_animate = false

      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          vim.api.nvim_create_user_command("Colorize", function()
            Snacks.terminal.colorize()
            vim.wo.number = true
            vim.wo.relativenumber = true
          end, {})

          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>os")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceil" }):map("<leader>oc")
          Snacks.toggle.diagnostics({ name = "Diagnostics" }):map("<leader>od")
          Snacks.toggle.treesitter():map("<leader>ot")
          Snacks.toggle.inlay_hints():map("<leader>oh")
          Snacks.toggle.dim():map("<leader>oi")
          Snacks.toggle.option("list", { name = "Visible Whitespace" }):map("<leader>o ")
          Snacks.toggle.option("wrap", { name = "Wrap Long Lines" }):map("<leader>ow")
          Snacks.toggle.indent():map("<leader>oz")
          Snacks.toggle.profiler():map("<leader>Lp")
          Snacks.toggle.profiler_highlights():map("<leader>Lh")

          Snacks.toggle
            .new({
              id = "virtual text",
              name = "DAP Virtual Text Toggle",
              get = function() return true end,
              set = function(_state) require("dap-view").virtual_text_toggle() end,
            })
            :map("<leader>ov")

          Snacks.toggle
            .new({
              id = "git blame",
              name = "Git Blame",
              get = function() return require("gitsigns.config").config.current_line_blame end,
              set = function(state) require("gitsigns").toggle_current_line_blame(state) end,
            })
            :map("<leader>ob")

          Snacks.toggle
            .new({
              id = "animate",
              name = "Animate",
              get = function() return vim.g.snacks_animate == true end,
              set = function(state)
                if state then
                  vim.g.snacks_animate = vim.fn.has("gui_running") == 0
                  require("smear_cursor").enabled = ((vim.fn.has("gui_running") == 0) and (vim.env.KITTY_WINDOW_ID == nil))

                  require("colorful-winsep.config").opts.animate.enabled = vim.g._colorful_winsep_enabled or "shift"
                  require("colorful-winsep").setup(require("colorful-winsep.config").opts)
                else
                  vim.g.snacks_animate = false
                  require("smear_cursor").enabled = false
                  require("colorful-winsep").setup()

                  vim.g._colorful_winsep_enabled = require("colorful-winsep.config").opts.animate.enabled
                  require("colorful-winsep.config").opts.animate.enabled = false
                  require("colorful-winsep").setup(require("colorful-winsep.config").opts)
                end
              end,
            })
            :map("<leader>oa")

          Snacks.toggle
            .new({
              id = "theme",
              name = "Light Theme",
              get = function() return vim.g.colors_name ~= "onedark" end,
              set = function(state)
                if state then
                  vim.cmd.colorscheme("catppuccin-latte")
                else
                  vim.cmd.colorscheme("onedark")
                end
              end,
            })
            :map("<leader>ol")

          Snacks.toggle
            .new({
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
            })
            :map("<leader>om")
        end,
      })
    end,
  },
}
