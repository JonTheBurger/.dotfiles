return {
  -- https://github.com/nvim-neotest/neotest
  "nvim-neotest/neotest",
  dependencies = {
    "alfaix/neotest-gtest",
    "nvim-lua/plenary.nvim",
    "nvim-neotest/neotest-python",
    "nvim-treesitter/nvim-treesitter",
  },
  ---@diagnostic disable missing-fields
  config = function(_, opts)
    require("neotest").setup({
      adapters = {
        require("neotest-gtest").setup({
          debug_adapter = "lldb",
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
      },
    })
  end,
  -- stylua: ignore start
  keys = {
    { "<leader>tt", function() require("neotest").run.run() end,                     desc = "Run Nearest" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest Test" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,   desc = "Run File" },
    { "<leader>te", function() require("neotest").summary.toggle() end,              desc = "Toggle Summary" },
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
