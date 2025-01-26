-- https://github.com/nvim-telescope/telescope.nvim
-- https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt
return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<C-p>",
        function()
          local function is_git_repo()
            vim.fn.system("git rev-parse --is-inside-work-tree")
            return vim.v.shell_error == 0
          end
          if is_git_repo() then
            require("telescope.builtin").git_files({ recurse_submodules = false })
          else
            require("telescope.builtin").find_files({ find_command = { "fd", "-t", "file", "-Luuu", fname } })
          end
        end,
        desc = "Find Git Files",
      },
      {
        "<C-M-p>",
        function()
          require("telescope.builtin").find_files({ find_command = { "fd", "-t", "file", "-Luuu", fname } })
        end,
        desc = "Find Files",
      },
      {
        "<C-f>",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Find Grep",
      }, -- Requires ripgrep
      -- {
      --   "gd",
      --   function()
      --     require("telescope.builtin").lsp_definitions({
      --       jump_type = "vsplit",
      --       reuse_win = true,
      --     })
      --   end,
      --   desc = "Find Definition",
      -- },
      {
        "<leader>fa",
        function()
          require("telescope.builtin").builtin()
        end,
        desc = "Find All",
      },
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({
            find_command = { "fd", "-t", "file", "-Luuu", fname }
          })
        end,
        desc = "Find All Files",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep({
            additional_args = {
              "-Luuu",
            },
          })
        end,
        desc = "Find Git Grep",
      }, -- Requires ripgrep
      {
        "<leader>fs",
        function()
          require("telescope.builtin").live_grep({
            additional_args = {
              "-Luuu",
            },
          })
        end,
        desc = "Find String",
      }, -- Requires ripgrep
      {
        "<leader>fw",
        function()
          require("telescope.builtin").grep_string()
        end,
        desc = "Find Word Under Cursor",
      }, -- Requires ripgrep
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Find Buffers",
      },
      {
        "<leader>fj",
        function()
          require("telescope.builtin").jumplist()
        end,
        desc = "Find Jumps",
      },
      {
        "<leader>f'",
        function()
          require("telescope.builtin").marks()
        end,
        desc = "Find Marks",
      },
      {
        "<leader>fc",
        function()
          require("telescope.builtin").commands()
        end,
        desc = "Find Commands",
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Find Help",
      },
      {
        "<leader>fk",
        function()
          require("telescope.builtin").keymaps()
        end,
        desc = "Find Keymaps",
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").lsp_references()
        end,
        desc = "Find References",
      },
      {
        "<leader>fi",
        function()
          require("telescope.builtin").lsp_incoming_calls()
        end,
        desc = "Find Incoming Calls",
      },
      {
        "<leader>fo",
        function()
          require("telescope.builtin").lsp_outgoing_calls()
        end,
        desc = "Find Outgoing Calls",
      },
      {
        "<leader>fm",
        function()
          require("telescope.builtin").lsp_document_symbols()
        end,
        desc = "Find Document Symbols",
      },
      {
        "<leader>fy",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols()
        end,
        desc = "Find Global Symbols",
      },
      {
        "<leader>fd",
        function()
          require("telescope.builtin").diagnostics({ bufnr = 0 })
        end,
        desc = "Find Warnings/Diagnostics",
      },
      {
        "<leader>fw",
        function()
          require("telescope.builtin").diagnostics()
        end,
        desc = "Find Global Warnings/Diagnostics",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
    },
    config = function()
      local actions = require "telescope.actions"
      local config = require "telescope.config"
      require("telescope").setup({
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
          },
          mappings = {
            i = {
              ["<C-f>"] = actions.send_to_qflist + actions.open_qflist,
            },
          },
          file_ignore_patterns = {
            ".git/",
          },
        },
      })
      require("telescope").load_extension("fzf")

      local finders = require("telescope.finders")
      local pickers = require("telescope.pickers")
      local make_entry = require("telescope.make_entry")
      local conf = require("telescope.config").values
      local cmake = require("cmake-tools")
      local function create_picker(title, fn)
        return function(opts)
          opts = opts or {}
          opts.cwd = opts.cwd or vim.fn.getcwd()

          pickers
              .new(opts, {
                prompt_title = title,
                finder = finders.new_table({
                  results = fn(),
                  entry_maker = make_entry.gen_from_file(opts),
                }),
                sorter = conf.file_sorter(opts),
                previewer = conf.file_previewer(opts),
              })
              :find()
        end
      end
      require("telescope").register_extension({
        exports = {
          cmake_tools = create_picker("CMake - Launch Targets", function()
            local result = cmake.get_config():launch_targets()
            local targets = {}
            for _, v in ipairs(result.targets) do
              table.insert(targets, v)
            end
            return targets
          end),
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        -- { "<leader>a", desc="align", mode = "nvxsot" },
      },
      triggers = {
        { "<auto>", mode = "nxsot" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  }
}
