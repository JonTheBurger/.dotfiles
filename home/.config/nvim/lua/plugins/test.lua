--- @module "lazy.nvim"
--- @type LazyPluginSpec[]
return {
  {
    -- https://github.com/nvim-neotest/neotest
    "nvim-neotest/neotest",
    enabled = not vim.g.vscode,
    dependencies = {
      "alfaix/neotest-gtest",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-python",
      "nvim-treesitter/nvim-treesitter",
      "orjangj/neotest-ctest",
      "stevearc/overseer.nvim",
    },
    --- @module "neotest"
    --- @type neotest.Config
    opts = {
      summary = {
        animated = true,
        expand_errors = true,
        mappings = {
          parent = "H",
          prev_sibling = "K",
          next_sibling = "J",
          prev_failed = "<",
          next_failed = ">",
          expand_all = "z",
          run = "r",
          debug = "d",
          attach = "a",
          stop = { "u", "s", "x" },
          output = "o",
          short = "O",
          help = "?",
          watch = "w",
          target = "t",
          jumpto = "i",
          expand = { "l", "h", "<CR>" },
          mark = { "<TAB>", "m" },
          run_marked = "R",
          debug_marked = "D",
          clear_marked = "M",
        },
      },
      discovery = {
        filter_dir = function(name, rel_path, root)
          local dir = name:lower()
          if dir:match("mock") or dir:match("external") or dir:match("tools") or dir:match("libraries") then return false end
          return true
        end,
      },
      running = { concurrent = 4, },
      floating = { border = "rounded", },
      diagnostics = { enabled = true, },
    },
    --- @module "neotest"
    --- @param opts neotest.Config
    config = function(opts)
      opts.adapters = {
          -- https://github.com/orjangj/neotest-ctest
          -- require("neotest-ctest").setup({
          --   frameworks = { "catch2", "doctest", "cpputest", }, -- "gtest"
          --   is_test_file = function(file_path)
          --     return file_path:lower():match("**test.cpp$")
          --   end,
          -- }),
          -- https://github.com/alfaix/neotest-gtest
          --- @module "neotest-gtest"
          require("neotest-gtest").setup({
            debug_adapter = "cppdbg",
            is_test_file = function(file_path) return file_path:lower():match("test%.cpp$") or file_path:match(".*GTest.*%.cpp$") end,
          }),
          -- https://github.com/nvim-neotest/neotest-python
          require("neotest-python")({
            args = { "-s", "--log-level", "DEBUG" },
            dap = { justMyCode = true },
            pytest_discover_instances = false,
          }),
          require("rustaceanvim.neotest"),
        }
      opts.consumers = {
        overseer = require("neotest.consumers.overseer"),
      }
      require("neotest").setup(opts)
      require("neotest-gtest.executables.global_registry")["for_dir"] = require("config.fn").util.find_cxx_tests
    end,
    -- stylua: ignore start
    keys = {
      { "<leader>tt",
        function()
          -- vim.cmd("OverseerClose")
          require("neotest").run.run()
        end,
        desc = "Run Nearest"
      },
      { "<leader>td",
        function()
          vim.cmd("OverseerClose")
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug Nearest Test"
      },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Run File" },
      { "<leader>te", function() require("neotest").summary.toggle() end,              desc = "Toggle Summary" },
      { "_t",         function() require("neotest").summary.toggle() end,              desc = "Toggle Tests" },
      { "<leader>tS", function() require("neotest").run.stop() end,                    desc = "Stop" },
      {
        "<leader>tT",
        function()
          require("neotest").run.run(vim.loop.cwd())
        end,
        desc = "Run All Test Files"
      },
      {
        "<leader>tO",
        function() require("neotest").output.open({ enter = true, auto_close = true }) end,
        desc = "Show Output"
      },
      {
        "<leader>to",
        function() require("neotest").output.open({ enter = true, auto_close = true }) end,
        desc = "Show Output"
      },
    },
    -- stylua: ignore end
  },
  {
    -- https://github.com/andythigpen/nvim-coverage
    "andythigpen/nvim-coverage",
    keys = {
      { "<leader>hc", function() require("coverage").show() end, desc = "Hover Coverage" },
    },
    opts = {
      auto_reload = true,
    },
  },
}
