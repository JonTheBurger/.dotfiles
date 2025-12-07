return {
  -- https://github.com/nvim-neotest/neotest
  "nvim-neotest/neotest",
  dependencies = {
    "alfaix/neotest-gtest",
    "nvim-lua/plenary.nvim",
    "nvim-neotest/neotest-python",
    "nvim-treesitter/nvim-treesitter",
    "orjangj/neotest-ctest",
  },
  ---@diagnostic disable missing-fields
  ---@param opts neotest.Config
  config = function(_, opts)
    -- Optional, but recommended, if you have enabled neotest's diagnostic option
    -- local neotest_ns = vim.api.nvim_create_namespace("neotest")
    -- vim.diagnostic.config({
    --   virtual_text = {
    --     format = function(diagnostic)
    --       -- Convert newlines, tabs and whitespaces into a single whitespace
    --       -- for improved virtual text readability
    --       local message = diagnostic.message:gsub("[\r\n\t%s]+", " ")
    --       return message
    --     end,
    --   },
    -- }, neotest_ns)

    require("neotest").setup({
      summary = {
        animated = false,
      },
      floating = {
        border = "rounded",
      },
      adapters = {
        -- https://github.com/orjangj/neotest-ctest
        require("neotest-ctest").setup({
          frameworks = { "catch2", "doctest", "cpputest", }, -- "gtest"
          is_test_file = function(file_path)
            return file_path:lower():match("**test.cpp$")
          end,
        }),
        -- https://github.com/alfaix/neotest-gtest
        require("neotest-gtest").setup({
          debug_adapter = "cppdbg",
          is_test_file = function(file_path)
            return file_path:lower():match("**test.cpp$")
          end,
        }),
        -- https://github.com/nvim-neotest/neotest-python
        require("neotest-python")({
          args = { "-s", "--log-level", "DEBUG" },
          dap = { justMyCode = true },
          pytest_discover_instances = false,
        }),
        require("rustaceanvim.neotest"),
      },
    })
    require("neotest-gtest.executables.global_registry")["for_dir"] = require("config.fn").util.find_cxx_tests
  end,
  -- stylua: ignore start
  keys = {
    { "<leader>tt", function() require("neotest").run.run() end,                     desc = "Run Nearest" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest Test" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Run File" },
    { "<leader>te", function() require("neotest").summary.toggle() end,              desc = "Toggle Summary" },
    { "<leader>Wt", function() require("neotest").summary.toggle() end,              desc = "Toggle Summary" },
    { "<leader>WT", function() require("neotest").output_panel.toggle() end,         desc = "Toggle Output Panel" },
    { "<leader>to", function() require("neotest").output_panel.toggle() end,         desc = "Toggle Output Panel" },
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
      function()
        require("neotest").output.open({
          enter = true, auto_close = true
        })
      end,
      desc = "Show Output"
    },
  },
  -- stylua: ignore end
}
