return {
  {
    --https://github.com/mfussenegger/nvim-lint
    "mfussenegger/nvim-lint",
    enabled = true,
    event = {
      "BufNewFile",
      "BufReadPre",
    },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        -- c = { "cppcheck" },
        cmake = { "cmakelint" },
        -- cpp = { "cppcheck",  "clazy" }, --
        python = { "mypy", "pylint" },
        yaml = { "yamllint" },
      }

      -- Remove a linter if it doesn't exist
      for _, linters in pairs(lint.linters_by_ft) do
        for i = #linters, 1, -1 do
          if vim.fn.executable(linters[i]) == 0 then
            table.remove(linters, i)
          end
        end
      end

      vim.api.nvim_create_user_command("Lint", function()
        lint.try_lint()
      end, { desc = "Lint" })
    end,
  },
  {
    --https://github.com/stevearc/conform.nvim
    "stevearc/conform.nvim",
    event = {
      "BufNewFile",
      "BufReadPre",
    },
    cmd = {
      "ConformInfo",
    },
    keys = {
      {
        "<leader>FF",
        function()
          if vim.bo.filetype == "bigfile" then
            local ext = vim.fn.expand("%:e")
            if ext == "json" then
              require("conform").format({ formatters = { "jq" } })
            else
              vim.notify("No bigfile formatter found for " .. ext)
            end
          else
            require("conform").format({ async = true })
          end
        end,
        mode = "n",
        desc = "Format buffer",
      },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        ["*"] = { "codespell" },
        ["_"] = { "trim_whitespace" },
        bash = { "shfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        cmake = { "gersemi" },
        html = { "prettier" },
        json = { "jq" },
        lua = { "stylua" },
        markdown = { "prettier", "injected" },
        python = { "ruff_format", "ruff_organize_imports" },
        sh = { "shfmt" },
        yaml = { "yamlfmt" },
        zsh = { "shfmt" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      formatters = {
        gersemi = {
          prepend_args = { "--indent", "2", "--line-length", "88", "--list-expansion", "favour-inlining" }
        },
        shfmt = {
          prepend_args = { "-i", "2" },
        },
        prettier = {
          prepend_args = { "--prose-wrap", "always", "--print-width", "80" },
        },
      },
    },
    init = function()
      vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

      vim.api.nvim_create_user_command("Fmt", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        require("conform").format({ async = true, range = range })
        if not range then
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              triggerKind = 1,
              diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 }),
              only = { "source.organizeImports" },
            },
          })
        end
      end, { desc = "Format", range = true })
    end,
  },
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
    -- https://github.com/folke/trouble.nvim
    "folke/trouble.nvim",
    enabled = not vim.g.vscode,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      { "<leader>wb", "<cmd>Trouble buffer_diagnostics toggle<CR>", desc = "Toggle Diagnostics (bottom)" },
      { "<leader>we", "<cmd>Trouble buffer_errors toggle win.position=right win.relative=win<CR>", desc = "Toggle Errors" },
      { "<leader>ww", "<cmd>Trouble buffer_diagnostics toggle win.position=right win.relative=win<CR>", desc = "Toggle Diagnostics" },
      { "_e",         "<cmd>Trouble buffer_errors toggle win.position=right win.relative=win<CR>", desc = "Toggle Errors" },
      { "_w",         "<cmd>Trouble buffer_diagnostics toggle win.position=right win.relative=win<CR>", desc = "Toggle Diagnostics (right)" },
      { "_y",         "<cmd>Trouble symbols toggle<CR>", desc = "Toggle Symbols" },
      { "<leader>y",  "<cmd>Trouble symbols toggle<CR>", desc = "Toggle Symbols" },
      { "_q",         "<cmd>Trouble qflist toggle<CR>", desc = "Toggle qflist" },
      { "<leader>Q",  "<cmd>Trouble qflist toggle<CR>", desc = "Toggle qflist" },
      { "_2",         "<cmd>Trouble todo toggle<CR>", desc = "Toggle TO DO" },
    },
    opts = {
      padding = false,
      modes = {
        buffer_diagnostics = {
          mode = "diagnostics", -- inherit from diagnostics mode
          filter = { buf = 0 },
        },
        buffer_errors = {
          mode = "diagnostics",
          filter = function(items)
            -- item = { buf, ft, dirname, filename, severity, source }
            return vim.tbl_filter(function(item)
              return (item.item.source == "cmake build")
            end, items)
          end,
        },
      }
    },
    init = function ()
      -- This is NOT RECOMMENDED, but I like it
      vim.api.nvim_create_autocmd("BufRead", {
        callback = function(ev)
          if vim.bo[ev.buf].buftype == "quickfix" then
            vim.schedule(function()
              vim.cmd([[cclose]])
              vim.cmd([[Trouble qflist open]])
            end)
          end
        end,
      })
    end
  },
}
