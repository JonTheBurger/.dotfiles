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
          find_command={ "fd", "--hidden", "-t", "f", fname }
        })
      end,
      desc="Find Files",
    },
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files({
          find_command={ "fd", "-Luuu", fname }
        })
      end,
      desc="Find All Files",
    },
    {
      "<leader>fv",
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
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep({
          additional_args = {
            "-Luuu",
          },
        })
      end,
      desc="Find Grep All",
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
      "<leader>f'",
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
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
  },
  config = function()
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
          targets = {}
          for _, v in ipairs(result.targets) do
            table.insert(targets, v)
          end
          return targets
        end),
      },
    })
  end,
}
