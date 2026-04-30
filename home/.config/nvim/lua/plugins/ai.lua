-- https://api.business.githubcopilot.com/models
copilot_node_command = "node"
if os.getenv("USER") == "vagrant" then copilot_node_command = "/home/vagrant/.nvm/versions/node/v24.13.1/bin/node" end

return {
  {
    -- https://github.com/copilotlsp-nvim/copilot-lsp
    "copilotlsp-nvim/copilot-lsp",
    enabled = true,
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
    -- enabled = os.getenv("USER") ~= "vagrant",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp",
    },
    cmd = {
      "Copilot",
    },
    event = "InsertEnter",
    opts = {
      copilot_node_command = copilot_node_command,
      suggestion = {
        debounce = 2500,
        trigger_on_accept = true,
        keymap = {
          -- accept = "<C-y>",
          -- accept_word = false,
          -- accept_line = false,
          -- next = "<A-]>",
          -- prev = "<A-[>",
          -- dismiss = "<C-]>",
        },
      },
      nes = {
        enabled = false,
        auto_trigger = true,
        keymap = {
          -- accept_and_goto = false,
          -- accept = false,
          -- dismiss = false,
          -- accept = true,
          -- accept_word = "<Right>",
          -- accept_line = "<C-y>",
          accept_and_goto = "<C-y>",
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
      "ravitemer/mcphub.nvim",
    },
    opts = {
      strategies = {
        chat = {
          -- adapter = {
          --   name = "copilot",
          --   model = "claude-sonnet-4",
          -- },
        },
      },
      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = "Prompt ", -- Prompt used for interactive LLM calls
          provider = "snacks", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
          opts = {
            show_default_actions = true, -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
            title = "CodeCompanion actions", -- The title of the action palette
          },
        },
      },
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionCLI",
      "CodeCompanionCommand",
      "CodeCompanionChat",
    },
    keys = {
      { "<leader>ai", "<cmd>CodeCompanionActions<CR>", desc = "Code Companion" },
      { "_a", "<cmd>CodeCompanionChat toggle<CR>", desc = "Toggle AI Chat" },
      -- { "<leader>C", "<cmd>CodeCompanionActions<CR>", desc = "Code Companion" },
    },
    init = function() vim.cmd("cab ai CodeCompanion") end,
  },
}
