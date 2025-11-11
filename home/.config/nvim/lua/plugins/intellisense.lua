return {
  {
    -- https://github.com/Saghen/blink.cmp
    "saghen/blink.cmp",
    dependencies = { "fang2hou/blink-copilot" },
    enabled = not vim.g.vscode,
    version = "*",

    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "super-tab", -- { "default", "super-tab" "enter" }
      },

      completion = {
        -- accept = {
        --   auto_brackets = {
        --     enabled = true,
        --     default_brackets = { "(", ")", "{", "}", "[", "]" },
        --   },
        -- },
        keyword = { range = "full" },
        -- Show documentation when selecting a completion item
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        menu = { auto_show = true },
        ghost_text = { enabled = true },
      },

      cmdline = {
        enabled = true,
        keymap = { preset = "inherit" },
        completion = {
          menu = { auto_show = true },
          -- ghost_text = { enabled = true },
        },
      },

      appearance = {
        -- Useful for when your theme doesn't support blink.cmp
        use_nvim_cmp_as_default = true,
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        -- Remove 'buffer' if you don't want text completions, by default it's only enabled when LSP returns no items
        default = { "lsp", "path", "snippets", "copilot" }, --"buffer" },
        providers = {
          snippets = {
            opts = {
              search_paths = {
                vim.fn.getcwd() .. "/.vscode",
                vim.fn.stdpath("config") .. "/snippets",
              },
            },
          },
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          }
        },
      },

      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },
  {
    -- https://github.com/windwp/nvim-autopairs
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      map_cr = true,
    },
  },
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
        c = { "cppcheck" },
        cmake = { "cmakelint" },
        cpp = { }, --"cppcheck",  clazy
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
        c = { "clang-format" },
        cpp = { "clang-format" },
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
        shfmt = {
          prepend_args = { "-i", "2" },
        },
        prettier = {
          prepend_args = { "--prose-wrap", "always", "--print-width", "80" },
        },
      },
    },
    init = function()
      -- vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>r", "", desc = "+refactor", mode = { "n", "v" } },
      {
        "<leader>ri",
        function()
          return require("refactoring").refactor("Inline Variable")
        end,
        mode = { "n", "v" },
        desc = "Inline Variable",
        expr = true,
      },
      {
        "<leader>rb",
        function()
          return require("refactoring").refactor("Extract Block")
        end,
        desc = "Extract Block",
        expr = true,
      },
      {
        "<leader>rf",
        function()
          return require("refactoring").refactor("Extract Block To File")
        end,
        desc = "Extract Block To File",
        expr = true,
      },
      {
        "<leader>rP",
        function()
          return require("refactoring").debug.printf({ below = false })
        end,
        desc = "Debug Print",
        expr = true,
      },
      {
        "<leader>rp",
        function()
          return require("refactoring").debug.print_var({ normal = true })
        end,
        desc = "Debug Print Variable",
        expr = true,
      },
      {
        "<leader>rc",
        function()
          return require("refactoring").debug.cleanup({})
        end,
        desc = "Debug Cleanup",
        expr = true,
      },
      {
        "<leader>rf",
        function()
          return require("refactoring").refactor("Extract Function")
        end,
        mode = {"n", "x"},
        desc = "Extract Function",
        expr = true,
      },
      {
        "<leader>rF",
        function()
          return require("refactoring").refactor("Extract Function To File")
        end,
        mode = "v",
        desc = "Extract Function To File",
        expr = true,
      },
      {
        "<leader>rx",
        function()
          return require("refactoring").refactor("Extract Variable")
        end,
        mode = "v",
        desc = "Extract Variable",
        expr = true,
      },
      {
        "<leader>rp",
        function()
          return require("refactoring").debug.print_var()
        end,
        mode = "v",
        desc = "Debug Print Variable",
        expr = true,
      },
    },
    opts = {
      prompt_func_return_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      prompt_func_param_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      printf_statements = {},
      print_var_statements = {},
      show_success_message = true, -- shows a message with information about the refactor on success
      -- i.e. [Refactor] Inlined 3 variable occurrences
    },
  },
  {
    -- https://github.com/danymat/neogen
    "danymat/neogen",
    version = "*",
    keys = {
      {
        "<leader>KK",
        function()
          require("neogen").generate()
        end,
        desc = "Generate docstring comment",
      },
    },
    opts = {
      snippet_engine = "nvim",
      insert_after_comment = true,
      binsert_after_comment = true,
      languages = {
        ["python"] = {
          template = {
            annotation_convention = "numpydoc",
          },
        },
      },
    },
  },
  {
    -- https://github.com/chrisgrieser/nvim-lsp-endhints
    "chrisgrieser/nvim-lsp-endhints",
    event = "LspAttach",
    opts = {},
  },
  {
    -- https://github.com/mrcjkb/rustaceanvim
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = { "rust" },
    lazy = false,
    init = function()
      local fn = require("config.fn")
      local codelldb = fn.fs.find_vscode_binary("vscode-lldb", "codelldb")
      local liblldb = fn.fs.find_vscode_binary("vscode-lldb", "liblldb")
      local cfg = require("rustaceanvim.config")

      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {},
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            -- you can also put keymaps in here
          end,
          default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {},
          },
        },
        -- DAP configuration
        dap = {
        },
      }
    end,
  },
  {
    "cordx56/rustowl",
    enabled = false,
    build = "cd rustowl && cargo install --path . --locked",
    lazy = false, -- This plugin is already lazy
    opts = {
      client = {
        on_attach = function(_, buffer)
          vim.keymap.set("n", "<leader>o", function()
            require("rustowl").toggle(buffer)
          end, { buffer = buffer, desc = "Toggle RustOwl" })
        end
      },
    },
  },
  {
    -- https://github.com/p00f/clangd_extensions.nvim
    "p00f/clangd_extensions.nvim",
    keys = {
      {
        "<leader>ct",
        "<cmd>ClangdTypeHierarchy<CR>",
        desc = "Clangd Type Hierarchy",
      },
    },
    ft = { "c", "cpp" },
    init = function()
      vim.api.nvim_create_user_command("A", "ClangdSwitchSourceHeader", {})
    end,
  },
  {
    -- https://github.com/Civitasv/cmake-tools.nvim/blob/master/docs/all_commands.md
    "Civitasv/cmake-tools.nvim",
    dependencies = {
      { "mfussenegger/nvim-dap" },
      { "nvim-lua/plenary.nvim" },
    },
    ft = { "cmake", "c", "cpp" },
    opts = {
      cmake_regenerate_on_save = false,
      cmake_executor = {
        name = "overseer",
        opts = {
          ---@class overseer.TaskDefinition
          new_task_opts = {
            name = "cmake build",
            components = {
              { "default" },
              { "on_output_parse", problem_matcher = "$gcc" },
              { "on_result_diagnostics" },
            },
          },
          ---@param task overseer.TaskDefinition
          on_new_task = function(task)
            require("overseer").open({ enter = false, direction = "bottom" })
          end,
        },
      },
    },
    keys = {
      { "<leader>cmb", "<cmd>CMakeBuild<CR>", desc = "CMake Build" },
      { "<leader>cmt", "<cmd>CMakeSelectBuildTarget<CR>", desc = "CMake Launch Target" },
      { "<leader>cmT", "<cmd>CMakeSelectLaunchTarget<CR>", desc = "CMake Launch Target" },
      { "<leader>cmd", "<cmd>CMakeDebug<CR>", desc = "CMake Debug" },
      { "<leader>cmr", "<cmd>CMakeRun<CR>", desc = "CMake Run" },
      { "<C-S-F5>", "<cmd>CMakeRun<CR>", desc = "CMake Run" },
    },
  },
  {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
    },
  },
  {
    -- https://github.com/MTDL9/vim-log-highlighting
    "MTDL9/vim-log-highlighting",
    ft = { "log" },
  },
}
