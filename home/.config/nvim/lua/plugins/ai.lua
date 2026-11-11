return {
  {
    -- https://github.com/copilotlsp-nvim/copilot-lsp
    "copilotlsp-nvim/copilot-lsp",
    enabled = require("config.prefs").ai_inline ~= "",
    event = { "LspAttach" },
    config = {
      nes = {
        move_count_threshold = 3,
      },
    },
    init = function() vim.g.copilot_nes_debounce = 3000 end,
  },
  {
    -- https://github.com/zbirenbaum/copilot.lua
    "zbirenbaum/copilot.lua",
    enabled = require("config.prefs").ai_inline ~= "",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp",
    },
    cmd = {
      "Copilot",
    },
    event = { "LspAttach" },
    keys = {
      -- stylua: ignore start
      { "<leader>a?", "<cmd>Copilot panel toggle<CR>", mode = { "n" }, desc = "Toggle AI Suggestion Panel" },
      { "_A",         "<cmd>Copilot panel toggle<CR>", mode = { "n" }, desc = "Toggle AI Suggestion Panel" },
      -- stylua: ignore end
    },
    opts = {
      copilot_node_command = require("config.fn").fs.find_vscode_node(),
      suggestion = {
        debounce = 2500,
        trigger_on_accept = true,
        keymap = {
          accept = false,
          accept_word = false,
          accept_line = false,
          next = false,
          prev = false,
          dismiss = false,
          toggle_auto_trigger = false,
        },
      },
      nes = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept_and_goto = "<C-y>",
          accept = false,
          dismiss = "<Esc>",
        },
      },
      copilot_model = "", -- Empty string selects the default
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        cmake = false,
        ["."] = false,
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
      vim.keymap.set({ "n", "i" }, "<C-y>", function()
        vim.cmd("stopinsert")
        require("copilot.nes").accept_and_goto()
      end, { desc = "Copilot NES accept and goto" })
    end,
  },
  {
    "fang2hou/blink-copilot",
    enabled = require("config.prefs").ai_inline ~= "",
    opts = {
      max_completions = 2,
      max_attempts = 4,
      debounce = 3000,
      auto_refresh = {
        backward = true,
        forward = true,
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    enabled = require("config.prefs").ai_chat ~= "" or require("config.prefs").ai_inline ~= "" ,
    dependencies = {
      -- "MeanderingProgrammer/render-markdown.nvim",
      "OXY2DEV/markview.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- "ravitemer/mcphub.nvim",
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionCLI",
      "CodeCompanionCommand",
      "CodeCompanionChat",
    },
    keys = {
      -- stylua: ignore start
      { "<leader>aa", "<cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "AI Actions" },
      { "<leader>ai", ":CodeCompanion ", mode = { "n", "v" },               desc = "AI..." },
      { "<leader>aI", ":CodeCompanionChat ", mode = { "n", "v" },           desc = "AI Chat..." },
      { "<leader>aF", ":CodeCompanion /fix", mode = { "v" },                desc = "AI Fix Code" },
      { "<leader>aX", ":CodeCompanion /explain", mode = { "v" },            desc = "AI Explain Code" },
      { "<leader>aW", ":CodeCompanion /lsp", mode = { "v" },                desc = "AI Explain Warnings" },
      { "<leader>aT", ":CodeCompanion /tests", mode = { "v" },              desc = "AI Write Tests" },
      { "<leader>aD", ":CodeCompanion /docs", mode = { "v" },               desc = "AI Write Docs" },
      { "<leader>aR", ":CodeCompanion /review", mode = { "v" },             desc = "AI Review Code" },
      { "<leader>ac", "<cmd>CodeCompanionChat toggle<CR>",                  desc = "Toggle AI Chat" },
      { "_a", "<cmd>CodeCompanionChat toggle<CR>",                          desc = "Toggle AI Chat" },
      -- stylua: ignore end
    },
    opts = {
      adapters = {
        http = {
          llama = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "http://localhost:9931", -- Your llama.cpp local address
              },
              schema = {
                model = {
                  default = "local-model", -- llama.cpp ignores this name and runs your loaded GGUF
                },
              },
            })
          end,
        },

        -- llama = function()
        --   return require("codecompanion.adapters").extend("openai_compatible", {
        --     env = {
        --       url = "http://localhost:9931",
        --     },
        --     schema = {
        --       model = {
        --         default = require("config.prefs").ai_model, -- llama.cpp ignores this name and uses whatever GGUF is loaded
        --       },
        --     },
        --   })
        -- end,
      },
      strategies = {
        chat = { adapter = require("config.prefs").ai_chat },
        inline = { adapter = require("config.prefs").ai_inline },
        cmd = { adapter = require("config.prefs").ai_chat },
      },
      interactions = {
        chat = {
          slash_commands = {
            -- https://codecompanion.olimorris.dev/configuration/chat-buffer#slash-commands
            ["file"] = { opts = { provider = "snacks" } },
            ["skills"] = { opts = { provider = "snacks" } },
            ["skills-group"] = { opts = { provider = "snacks" } },
          },
          opts = {
            context_management = {
              enabled = true,
            },
            prompt_decorator = function(message, _adapter, _context)
              ---https://codecompanion.olimorris.dev/configuration/chat-buffer#prompt-decorator
              if require("config.prefs").ai_chat == "opencode" then
                return string.format([[<prompt>%s</prompt>]], message)
              end
              return message
            end,
          },
        },
        background = { adapter = require("config.prefs").ai_inline },
      },
      prompt_library = {
        -- https://codecompanion.olimorris.dev/configuration/prompt-library#basic-structure
        markdown = {
          dirs = {
            -- For more examples, see codecompanion.nvim/lua/codecompanion/actions/builtins/unit_tests.md
            vim.fn.stdpath("config") .. "/lua/prompts",
          },
        },
      },
      rules = {
        -- https://codecompanion.olimorris.dev/configuration/rules#rule-groups
        my_project_rules = {
          description = "Current Project's Rules",
          files = {
            "AGENTS.md",
            "CONTRIBUTING.md",
            "docs/**/*.md",
          },
        },
        opts = {
          chat = {
            autoload = "my_project_rules",
          },
        },
      },
      display = {
        action_palette = {
          provider = "snacks",
          opts = {
            title = "AI Assist",
            show_default_actions = true,
            show_default_prompt_library = true,
            show_preset_prompts = true,
          },
        },
        diff = {
          enabled = true,
        },
        chat = {
          icons = {
            chat_context = "📎️",
          },
          show_settings = true,
          fold_context = true,
        },
      },
      opts = {
        language = "English",
        log_level = "INFO",
      },
    },
    init = function()
      -- vim.cmd.cabbrev("ai CodeCompanion")
      require("prompts.spinner").init()
    end,
  },
}
