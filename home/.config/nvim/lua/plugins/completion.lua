---@module "lazy"
---@type LazyPluginSpec[]
return {
  {
    -- https://github.com/mason-org/mason.nvim
    "mason-org/mason.nvim",
    ---@module "mason.settings"
    ---@type MasonSettings
    opts = {},
  },
  {
    -- https://github.com/Saghen/blink.cmp
    "saghen/blink.cmp",
    dependencies = {
      "fang2hou/blink-copilot",
      "rcarriga/cmp-dap",
      "saghen/blink.compat",
    },
    enabled = not vim.g.vscode,
    version = "1.*",

    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          require("copilot.suggestion").dismiss()
          vim.b.copilot_suggestion_hidden = true
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuClose",
        callback = function() vim.b.copilot_suggestion_hidden = false end,
      })
    end,

    opts_extend = { "sources.default" },

    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      enabled = function() return vim.bo.buftype ~= "prompt" or vim.startswith(vim.bo.filetype, "dap") end,

      keymap = {
        preset = "super-tab", -- { "default", "super-tab" "enter" }
      },

      completion = {
        keyword = { range = "full" },
        accept = {
          ---@diagnostic disable-next-line: missing-fields
          auto_brackets = { enabled = true },
          create_undo_point = true,
        },
        ---@diagnostic disable-next-line: missing-fields
        documentation = { auto_show = true, auto_show_delay_ms = 350 },
        ---@diagnostic disable-next-line: missing-fields
        menu = { auto_show = true, draw = { treesitter = { "lsp" } } },
        ---@diagnostic disable-next-line: missing-fields
        ghost_text = { enabled = true },
      },

      cmdline = {
        enabled = true,
        keymap = { preset = "inherit" },
        sources = { "cmdline", "lazydev", "buffer" },
        completion = {
          menu = { auto_show = true },
          ghost_text = { enabled = true },
        },
      },

      term = {
        enabled = true,
        keymap = { preset = "inherit" },
        completion = {
          menu = { auto_show = true },
        },
        sources = { "path" },
      },

      ---@diagnostic disable-next-line: missing-fields
      appearance = {
        -- Useful for when your theme doesn't support blink.cmp
        use_nvim_cmp_as_default = true,
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      ---@diagnostic disable-next-line: missing-fields
      sources = {
        default = function()
          local srcs = { "lsp", "path", "snippets", "copilot" }
          if vim.startswith(vim.bo.filetype, "dap") then
            table.insert(srcs, "dap")
            table.insert(srcs, "buffer")
          end
          return srcs
        end,

        per_filetype = {
          codecompanion = { "codecompanion" },
        },

        providers = {
          copilot = {
            score_offset = 10,
            module = "blink-copilot",
            name = "copilot",
            async = true,
          },
          dap = {
            score_offset = 4,
            module = "blink.compat.source",
            name = "dap",
          },
          snippets = {
            score_offset = 3,
            module = "blink.cmp.sources.snippets",
            name = "Snippets",
            opts = {
              search_paths = {
                vim.fn.getcwd() .. "/.vscode",
                vim.fn.stdpath("config") .. "/snippets",
              },
            },
          },
          lazydev = {
            score_offset = 2,
            module = "lazydev.integrations.blink",
            name = "LazyDev",
          },
          lsp = {
            score_offset = 2,
            module = "blink.cmp.sources.lsp",
            name = "LSP",
          },
          path = {
            score_offset = 1,
            module = "blink.cmp.sources.path",
            name = "Path",
          },
          buffer = {
            score_offset = -1,
            module = "blink.cmp.sources.path",
            name = "Buffer",
            opts = {
              -- get all "normal" buffers
              get_bufnrs = function()
                return vim.tbl_filter(function(bufnr)
                  local visible = require("config.fn").buf.get_visible()
                  return vim.bo[bufnr].buftype == "" and vim.tbl_contains(visible, bufnr)
                end, vim.api.nvim_list_bufs())
              end,
            },
          },
        },
      },

      signature = { enabled = true },
    },
  },
  {
    -- https://github.com/danymat/neogen
    "danymat/neogen",
    cmd = "Neogen",
    keys = {
      -- stylua: ignore start
      { "<leader>/", function() require("neogen").generate() end, desc = "Comment Item Under Cursor", },
      -- stylua: ignore end
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
    ---@module "nvim-lsp-endhints"
    ---@type LspEndhints.config
    ---@diagnostic disable-next-line: missing-fields
    opts = {},
  },
  {
    -- https://github.com/folke/lazydev.nvim
    "folke/lazydev.nvim",
    ft = "lua",
    ---@module "lazydev.nvim"
    ---@type "lazydev.Config"
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
        { path = "mini.nvim", words = { "Mini" } },
      },
    },
  },
  {
    -- https://github.com/mrcjkb/rustaceanvim
    "mrcjkb/rustaceanvim",
    version = "^9",
    ft = { "rust" },
    init = function()
      local fn = require("config.fn")
      local codelldb = fn.fs.find_vscode_binary("vscode-lldb", "codelldb")
      local liblldb = fn.fs.find_vscode_binary("vscode-lldb", "liblldb")
      local cfg = require("rustaceanvim.config")

      ---@module "rustaceanvim.config"
      ---@type rustaceanvim.Opts
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
        dap = {},
      }
    end,
  },
  {
    -- https://github.com/cordx56/rustowl
    "cordx56/rustowl",
    enabled = true,
    build = "cargo install --path . --locked",
    ft = { "rust" },
    opts = {
      client = {
        on_attach = function(_, buffer)
          vim.keymap.set("n", "<leader>?", function() require("rustowl").toggle(buffer) end, { buffer = buffer, desc = "Toggle RustOwl" })
        end,
      },
    },
  },
  {
    -- https://github.com/p00f/clangd_extensions.nvim
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp" },
    keys = {
      -- stylua: ignore start
      { "<leader>ca", "<cmd>ClangdAST<CR>", mode = { "n", "x" }, desc = "Clangd AST" },
      { "<leader>ci", "<cmd>ClangdSymbolInfo<CR>",               desc = "Clangd Symbol Info" },
      { "<leader>ct", "<cmd>ClangdTypeHierarchy<CR>",            desc = "Clangd Type Hierarchy", },
      { "<leader>cm", "<cmd>ClangdMemoryUsage<CR>",              desc = "Clangd Memory", },
      { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<CR>",       desc = "Clangd GoTo Header", },
      -- stylua: ignore end
    },
    ---@module "clangd_extensions.nvim"
    ---@type ClangdExt.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {},
    init = function() vim.api.nvim_create_user_command("A", "ClangdSwitchSourceHeader", {}) end,
  },
  {
    -- https://github.com/seblyng/roslyn.nvim
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {},
  },
  {
    -- https://github.com/fei6409/log-highlight.nvim
    "fei6409/log-highlight.nvim",
    ft = { "log" },
    opts = {
      ---@type string|string[]: File extensions. Default: 'log'
      extension = "log",
      ---@type string|string[]: File names or full file paths.
      filename = {
        "syslog",
      },
      ---@type string|string[]: File name/path glob patterns.
      pattern = {
        "%/var%/log%/.*",
        "console%-ramoops.*",
        "log.*%.txt",
        "logcat.*",
      },
      ---@type table<string, string|string[]>: Custom keywords to highlight.
      keyword = {
        error = { "ERROR", "FAILED" },
        warning = { "WARN", "WARNING" },
        info = { "INFO", "INFORMATION", "STATUS" },
        debug = { "DEBUG", "TRACE" },
        pass = { "PASS", "PASSED", "OK", "SUCCESS" },
      },
    },
  },
  {
    -- https://github.com/jontheburger/nvim-elf-file
    "jontheburger/nvim-elf-file",
    enabled = not vim.g.vscode,
    opts = {},
  },
}
