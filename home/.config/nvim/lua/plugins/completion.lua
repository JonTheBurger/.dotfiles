return {
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
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,

    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      enabled = function()
        return vim.bo.buftype ~= "prompt" or vim.startswith(vim.bo.filetype, "dap")
      end,

      keymap = {
        preset = "super-tab", -- { "default", "super-tab" "enter" }
      },

      completion = {
        keyword = { range = "full" },
        accept = { auto_brackets = { enabled = true }, },
        documentation = { auto_show = true },
        menu = { auto_show = true, draw = { treesitter = { "lsp" } }, },
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

      appearance = {
        -- Useful for when your theme doesn't support blink.cmp
        use_nvim_cmp_as_default = true,
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = function(ctx)
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
          lsp = {
            score_offset = 2,
          },
          path = {
            score_offset = 1,
          },
          snippets = {
            opts = {
              search_paths = {
                vim.fn.getcwd() .. "/.vscode",
                vim.fn.stdpath("config") .. "/snippets",
              },
            },
            score_offset = 3,
          },
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 10,
            async = true,
          },
          buffer = {
            opts = {
              -- get all "normal" buffers
              get_bufnrs = function()
                return vim.tbl_filter(function(bufnr)
                  local visible = require("config.fn").buf.get_visible()
                  return vim.bo[bufnr].buftype == '' and vim.tbl_contains(visible, bufnr)
                end, vim.api.nvim_list_bufs())
              end
            },
            score_offset = -1,
          },
          dap = {
            name = "dap",
            module = "blink.compat.source",
            score_offset = 4,
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 2,
          },
        },
      },

      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },
  {
    -- https://github.com/danymat/neogen
    "danymat/neogen",
    version = "*",
    keys = {
      {
        "<leader>/",
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
    -- https://github.com/folke/lazydev.nvim
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
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
    opts = {
      inline = false,
      only_current_line = false,
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
    init = function()
      vim.api.nvim_create_user_command("A", "ClangdSwitchSourceHeader", {})
    end,
  },
  {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {},
  },
  {
    -- https://github.com/MTDL9/vim-log-highlighting
    "MTDL9/vim-log-highlighting",
    ft = { "log" },
  },
  {
    -- https://github.com/jontheburger/nvim-elf-file
    "jontheburger/nvim-elf-file",
    enabled = not vim.g.vscode,
    opts = {},
  }
}
