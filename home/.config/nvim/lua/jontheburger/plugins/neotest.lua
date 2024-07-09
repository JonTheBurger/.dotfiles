-- alfaix/neotest-gtest
local function starts_with(str, start)
   return str:sub(1, #start) == start
end

local function ends_with(str, ending)
   return ending == "" or str:sub(-#ending) == ending
end

return {
  "nvim-neotest/neotest",
  dependencies = {
    "alfaix/neotest-gtest",
    "nvim-lua/plenary.nvim",
    "nvim-neotest/neotest-python",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    -- Can be a list of adapters like what neotest expects,
    -- or a list of adapter names,
    -- or a table of adapter names, mapped to adapter configs.
    -- The adapter will then be automatically loaded with the config.
    adapters = {
      ["neotest-gtest"] = {
        debug_adapter = "lldb",
        is_test_file = function(file_path)
          return file_path:lower():match("**test.cpp$")
        end,
      },
      ["neotest-python"] = {
        args = {
          "-s",
        },
      },
    },
    status = { virtual_text = true },
    output = { enabled = true, open_on_run = false, },
    output_panel = { enabled = true, },
    quickfix = { enabled = true, open = false, },
  },
  config = function(_, opts)
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          -- Replace newline and tab characters with space for more compact diagnostics
          local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, neotest_ns)

    -- Keep NeoTest out of BufferLine
    vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
      pattern = { "Neotest *", },
      callback = function()
        vim.cmd("setl nobuflisted")
      end,
    })
    -- Same with the unnamed test result buffer
    vim.api.nvim_create_autocmd({ "BufEnter", }, {
        pattern = { "*", },
        callback = function(args)
          if args.file == "" then
            vim.api.nvim_buf_set_option(args.buf, "buflisted", false)
          end
        end,
      }
    )


    if opts.adapters then
      local adapters = {}
      for name, config in pairs(opts.adapters or {}) do
        if type(name) == "number" then
          if type(config) == "string" then
            config = require(config)
          end
          adapters[#adapters + 1] = config
        elseif config ~= false then
          local adapter = require(name)
          if type(config) == "table" and not vim.tbl_isempty(config) then
            local meta = getmetatable(adapter)
            if adapter.setup then
              adapter.setup(config)
            elseif meta and meta.__call then
              adapter(config)
            else
              error("Adapter " .. name .. " does not support setup")
            end
          end
          adapters[#adapters + 1] = adapter
        end
      end
      opts.adapters = adapters
    end

    require("neotest").setup(opts)

  end,
  keys = {
    { "<leader>tt", function() require("neotest").run.run() end, desc = "Run Nearest" },
    { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest Test" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
    { "<leader>tD", function() require("neotest").run.run(vim.fn.expand("%"), {strategy = "dap"}) end, desc = "Debug File" },
    { "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
    { "<leader>te", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
    { "<leader>tO", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
    { "<leader>to", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
    { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
  },
}
