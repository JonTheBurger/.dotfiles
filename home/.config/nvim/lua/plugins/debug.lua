--[[ TO DEBUG NEOVIM:
1. Open a Neovim instance (instance A)
2. Launch the DAP server with (A): <leader>dN
   (AKA :lua require"osv".launch({port=8086}))
3. Open another Neovim instance (instance B)
4. Open `util.lua` (B)
5. Place a breakpoint on line 30 using (B): <F9>
   (AKA :lua require"dap".toggle_breakpoint())
6. Connect the DAP client using (B): <F5>
   (AKA :lua require"dap".continue())
7. Run `util.lua` in the other instance (A):
  :luafile util.lua
8. The breakpoint should hit and freeze the instance (B)
--]]
return {
  {
    -- https://github.com/mfussenegger/nvim-dap
    "mfussenegger/nvim-dap",
    enabled = not vim.g.vscode,
    dependencies = {
      { "jbyuki/one-small-step-for-vimkind" },
      { "nvim-neotest/nvim-nio" },
      { "theHamsta/nvim-dap-virtual-text" },
    },
    -- stylua: ignore start
    keys = {
      -- Custom
      { "<leader>dk",  function() require("dap").up() end,                                          desc = "Go Up 1 Stack Frame", },
      { "<leader>dj",  function() require("dap").down() end,                                        desc = "Go Down 1 Stack Frame", },
      { "<M-d>",       function() require("dap.ui.widgets").hover() end,                            desc = "Hover Variables", },
      { "<F1>",        function() require("dap.ui.widgets").hover() end,                            desc = "Hover Variables", },
      { "<S-F4>",      function() require("dapui").eval() end,                                      desc = "Evaluate",               mode = { "n", "v" }, },
      { "<F5>",        function() require("dap").continue() end,                                    desc = "Continue", },
      { "<F8>",        function() require("dap").run_to_cursor() end,                               desc = "Run to Cursor", },
      { "<F9>",        function() require("dap").toggle_breakpoint() end,                           desc = "Toggle Breakpoint", },
      { "<F10>",       function() require("dap").step_over() end,                                   desc = "Step Over", },
      { "<F11>",       function() require("dap").step_into() end,                                   desc = "Step In", },
      { "<S-F11>",     function() require("dap").step_out() end,                                    desc = "Step Out", },
      -- Standard
      { "<leader>dR",  function() require("dap").run_to_cursor() end,                               desc = "Run to Cursor", },
      { "<leader>dU",  function() require("dapui").toggle() end,                                    desc = "Toggle UI", },
      { "<leader>db",  function() require("dap").step_back() end,                                   desc = "Step Back", },
      { "<leader>dc",  function() require("dap").continue() end,                                    desc = "Continue", },
      { "<leader>dd",  function() require("dap").disconnect() end,                                  desc = "Disconnect", },
      { "<leader>de",  function() require("dapui").eval() end,                                      desc = "Evaluate",               mode = { "n", "v" }, },
      { "<leader>dg",  function() require("dap").session() end,                                     desc = "Get Session", },
      { "<leader>dh",  function() require("dap.ui.widgets").hover() end,                            desc = "Hover Variables", },
      { "<leader>dS",  function() require("dap.ui.widgets").scopes() end,                           desc = "Scopes", },
      { "<leader>di",  function() require("dap").step_into() end,                                   desc = "Step Into", },
      { "<leader>do",  function() require("dap").step_over() end,                                   desc = "Step Over", },
      { "<leader>dp",  function() require("dap").pause.toggle() end,                                desc = "Pause", },
      { "<leader>dq",  function() require("dap").close() end,                                       desc = "Quit", },
      { "<leader>dr",  function() require("dap").repl.toggle() end,                                 desc = "Toggle REPL", },
      { "<leader>ds",  function() require("dap").continue() end,                                    desc = "Start", },
      { "<leader>dt",  function() require("dap").toggle_breakpoint() end,                           desc = "Toggle Breakpoint", },
      { "<leader>dx",  function() require("dap").terminate() end,                                   desc = "Terminate", },
      { "<leader>du",  function() require("dap").step_out() end,                                    desc = "Step Out", },
      { "<leader>dE",  function() require("dapui").eval(vim.fn.input "[Expression] > ") end,        desc = "Evaluate Input", },
      { "<leader>dC",  function() require("dap").set_breakpoint(vim.fn.input "[Condition] > ") end, desc = "Conditional Breakpoint", },
      { "<leader>dN",  function() require("osv").launch({ port = 8086 }) end,                       desc = "Launch nvim Server",     noremap = true, },
    },
    -- stylua: ignore end
    opts = {
      -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
      adapters = {
        lldb = {
          id = "lldb",
          name = "lldb",
          type = "executable",
          command = "lldb-dap",
        },
        cppdbg = {
          id = "cppdbg",
          name = "cppdbg",
          type = "executable",
          command = require("config.fn").fs.find_vscode_binary("ms-vscode.cpptools", "OpenDebugAD7"),
        },
        cmake = {
          id = "cmake",
          name = "cmake",
          type = "pipe",
          executable = {
            command = "cmake",
            args = { "--debugger", "--debugger-pipe", "${pipe}", "-B", "build/dap" },
          },
          pipe = "${pipe}",
        },
        -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python
        python = function(callback, config)
          if config.request == "attach" then
            local port = (config.connect or config).port
            local host = (config.connect or config).host or "127.0.0.1"
            callback({
              type = "server",
              port = assert(port, "`connect.port` is required for a python `attach` configuration"),
              host = host,
              options = { source_filetype = "python" },
            })
          else
            callback({
              type = "executable",
              command = "python",
              args = { "-m", "debugpy.adapter" },
              options = { source_filetype = "python" },
            })
          end
        end,
        -- https://github.com/jbyuki/one-small-step-for-vimkind?tab=readme-ov-file#configuration
        nlua = function(callback, config)
          callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
        end,
      },
      launchers = {
        lldb = {
          name = "lldb: launch",
          type = "lldb",      -- matches the adapter
          request = "launch", -- could also attach to a currently running process
          program = require("config.fn").util.select_cxx_executable,
          cwd = "${workspaceFolder}",
          env = { "NOCOLOR=1" },
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
        -- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
        cppdbg = {
          name = "gdb: launch",
          type = "cppdbg",
          request = "launch",
          program = require("config.fn").util.select_cxx_executable,
          cwd = "${workspaceFolder}",
          env = { "NOCOLOR=1" },
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
          setupCommands = {
            {
              text = "-enable-pretty-printing",
              description = "enable pretty printing",
              ignoreFailures = false,
            },
          },
        },
        -- CMake https://github.com/mfussenegger/nvim-dap/pull/992
        cmake = {
          name = "cmake: debug",
          type = "cmake",
          request = "launch",
        },
        python_file = {
          type = "python",
          request = "launch",
          name = "python launch file",
          program = "${file}",
          pythonPath = require("config.fn").os.find_python,
        },
        -- https://github.com/jbyuki/one-small-step-for-vimkind?tab=readme-ov-file#configuration
        nlua = {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
        },
      },
    },
    config = function(_, opts)
      local dap = require("dap")

      dap.adapters = opts.adapters
      dap.configurations = {
        c = {
          opts.launchers.lldb,
          opts.launchers.cppdbg,
        },
        cpp = {
          opts.launchers.lldb,
          opts.launchers.cppdbg,
        },
        cmake = {
          opts.launchers.cmake,
        },
        python = {
          opts.launchers.python_file,
        },
        lua = {
          opts.launchers.nlua,
        },
        -- rust = {
        --   opts.launchers.lldb,
        -- },
      }
    end,
  },
  {
    -- https://github.com/rcarriga/nvim-dap-ui
    "rcarriga/nvim-dap-ui",
    enabled = not vim.g.vscode,
    dependencies = {
      { "mfussenegger/nvim-dap" },
    },
    opts = {
      layouts = {
        {
          position = "left",
          size = 40,
          elements = {
            { id = "breakpoints", size = 0.10 },
            { id = "stacks",      size = 0.30 },
            { id = "scopes",      size = 0.30 },
            { id = "watches",     size = 0.30 },
          },
        },
        {
          position = "bottom",
          size = 10,
          elements = {
            { id = "console", size = 0.20 },
            { id = "repl",    size = 0.80 },
          },
        },
      },
    },
    config = function(_, opts)
      local dapui = require("dapui")
      dapui.setup(opts)

      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    -- https://github.com/theHamsta/nvim-dap-virtual-text
    "theHamsta/nvim-dap-virtual-text",
    enabled = not vim.g.vscode,
    opts = {},
  },
}
