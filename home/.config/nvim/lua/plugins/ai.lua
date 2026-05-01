-- https://api.business.githubcopilot.com/models
copilot_node_command = "node"
if vim.uv.fs_stat("/home/vagrant/.nvm/versions/node/v24.13.1/bin/node") then copilot_node_command = "/home/vagrant/.nvm/versions/node/v24.13.1/bin/node" end

return {
  {
    -- https://github.com/copilotlsp-nvim/copilot-lsp
    "copilotlsp-nvim/copilot-lsp",
    enabled = true,
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
    enabled = true,
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
      copilot_node_command = copilot_node_command,
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
      copilot_model = "",
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
  },
  {
    "fang2hou/blink-copilot",
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
    dependencies = {
      "MeanderingProgrammer/render-markdown.nvim",
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
      interactions = {
        chat = {
          adapter = {
            name = "copilot",
            model = "gpt-4.1",
          },
          slash_commands = {
            -- https://codecompanion.olimorris.dev/configuration/chat-buffer#slash-commands
            ["file"] = { opts = { provider = "snacks" } },
          },
          opts = {
            context_management = {
              enabled = true,
            },
            prompt_decorator = function(message, _adapter, _context)
              ---https://codecompanion.olimorris.dev/configuration/chat-buffer#prompt-decorator
              return string.format([[<prompt>%s</prompt>]], message)
            end,
          },
        },
        inline = { adapter = "copilot" },
        cmd = { adapter = "copilot" },
        background = { adapter = "copilot" },
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
      vim.cmd.cabbrev("ai CodeCompanion")
      require("prompts.spinner").init()
    end,
  },
}
