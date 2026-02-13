-- https://api.business.githubcopilot.com/models
copilot_node_command = "node"
if os.getenv("USER") == "vagrant" then
  copilot_node_command = "/home/vagrant/.nvm/versions/node/v24.13.1/bin/node"
end

return {
  {
    "zbirenbaum/copilot.lua",
    -- enabled = os.getenv("USER") ~= "vagrant",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp",
    },
    cmd = {
      "Copilot",
    },
    event = "InsertEnter",
    opts = {
      copilot_node_command=copilot_node_command,
      suggestion = {
        debounce = 3500,
        trigger_on_accept = true,
        keymap = {
          -- accept = "<C-y>",
          -- accept_word = false,
          -- accept_line = false,
          -- next = "<M-]>",
          -- prev = "<M-[>",
          -- dismiss = "<C-]>",
        },
      },
      nes = {
        enabled = false,
        auto_trigger = false,
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
    }
  },
  {
    "olimorris/codecompanion.nvim",
    opts = {
      strategies = {
        chat = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4",
          },
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
    keys = {
      { "<leader>C", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true, desc = "Code Companion" }},
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "codecompanion" },
    opts = {},
  },
}
