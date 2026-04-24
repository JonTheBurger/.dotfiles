---@module "lazy"
---@type LazyPluginSpec[]
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
    ---@module "neotest"
    ---@type neotest.Config
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
        filter_dir = function(name, _rel_path, _root) return not require("config.fn").str.match_any(name:lower(), require("config.preferences").ignore_patterns) end,
      },
      running = { concurrent = 4 },
      floating = { border = "rounded" },
      diagnostics = { enabled = true },
    },
    ---@module "neotest"
    ---@param opts neotest.Config
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
        ---@module "neotest-gtest"
        require("neotest-gtest").setup({
          debug_adapter = "cppdbg",
          is_test_file = function(file_path)
            return require("config.fn").str.match_any(file_path:lower(), {
              "test%.cpp$",
              ".*gtest.*%.cpp$",
            })
          end,
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
      ---@diagnostic disable: undefined-field
      require("neotest").setup(opts)
      ---@diagnostic disable-next-line: assign-type-mismatch
      require("neotest-gtest.executables.global_registry")["for_dir"] = require("config.fn").util.find_cxx_tests
    end,
    -- stylua: ignore start
    ---@diagnostic disable: undefined-field
    keys = {
      { "_t",         function() require("neotest").summary.toggle() end,              desc = "Test Explorer" },
      { "<leader>te", function() require("neotest").summary.toggle() end,              desc = "Test Explorer" },
      { "<leader>tt", function() require("neotest").run.run() end,                     desc = "Test Run Nearest" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Test Debug Nearest" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Test Run File" },
      { "<leader>ts", function() require("neotest").run.stop() end,                    desc = "Test Stop" },
      { "<leader>ta", function() require("neotest").run.run(vim.uv.cwd()) end,         desc = "Test All" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Test Output" },
      { "<leader>ht", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Test Output" },
    },
    -- stylua: ignore end
  },
  {
    -- https://github.com/andythigpen/nvim-coverage
    "andythigpen/nvim-coverage",
    keys = {
      { "<leader>hc", function() require("coverage").show() end, desc = "Coverage: Hover" },
    },
    opts = {
      auto_reload = true,
    },
  },
}
