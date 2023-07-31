-- https://github.com/nvim-telescope/telescope.nvim
return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.2",
  keys = {
    {
      "<leader>fa",
      function()
        require("telescope.builtin").builtin()
      end,
      desc="Find All",
    },
    {
      "<C-p>",
      function()
        require("telescope.builtin").find_files({
          find_command={ "fd", "", fname }
        })
      end,
      desc="Find Project Files",
    },
    {
      "<leader>fp",
      function()
        require("telescope.builtin").find_files({
          find_command={ "fd", fname }
        })
      end,
      desc="Find Project Files",
    },
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files({
          find_command={ "fd", "-HIi", fname }
        })
      end,
      desc="Find All Files",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").git_files()
      end,
      desc="Find Git Files",
    },
    {
      "<C-f>",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc="Find Grep",
    }, -- Requires ripgrep
    {
      "<leader>fj",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc="Find Grep",
    }, -- Requires ripgrep
    {
      "<leader>fw",
      function()
        require("telescope.builtin").grep_string()
      end,
      desc="Find Word Under Cursor",
    }, -- Requires ripgrep
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc="Find Buffers",
    },
    {
      "<leader>fm",
      function()
        require("telescope.builtin").marks()
      end,
      desc="Find Marks",
    },
    {
      "<leader>fc",
      function()
        require("telescope.builtin").commands()
      end,
      desc="Find Commands",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc="Find Help",
    },
    {
      "<leader>fk",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc="Find Keymaps",
    },
    {
      "<leader>lr",
      function()
        require("telescope.builtin").lsp_references()
      end,
      desc="Find References",
    },
    {
      "<leader>li",
      function()
        require("telescope.builtin").lsp_incoming_calls()
      end,
      desc="Find Incoming Calls",
    },
    {
      "<leader>lo",
      function()
        require("telescope.builtin").lsp_outgoing_calls()
      end,
      desc="Find Outgoing Calls",
    },
    {
      "<leader>ly",
      function()
        require("telescope.builtin").lsp_document_symbols()
      end,
      desc="Find Symbols",
    },
    {
      "<leader>lm",
      function()
        require("telescope.builtin").lsp_workspace_symbols()
      end,
      desc="Find Global Symbols",
    },
    {
      "<leader>ld",
      function()
        require("telescope.builtin").diagnostics({bufnr=0})
      end,
      desc="Find Warnings/Diagnostics",
    },
    {
      "<leader>lw",
      function()
        require("telescope.builtin").diagnostics()
      end,
      desc="Find Global Warnings/Diagnostics",
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
