return {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "rcarriga/nvim-dap-ui" },
    { "nvim-neotest/nvim-nio" },
    { "theHamsta/nvim-dap-virtual-text" },
    { "nvim-telescope/telescope-dap.nvim" },
    { "jbyuki/one-small-step-for-vimkind" },
  },
  keys = {
    { "<leader>dR", function() require("dap").run_to_cursor() end, desc = "Run to Cursor", },
    { "<leader>dE", function() require("dapui").eval(vim.fn.input "[Expression] > ") end, desc = "Evaluate Input", },
    { "<leader>dC", function() require("dap").set_breakpoint(vim.fn.input "[Condition] > ") end, desc = "Conditional Breakpoint", },
    { "<leader>dU", function() require("dapui").toggle() end, desc = "Toggle UI", },
    { "<leader>db", function() require("dap").step_back() end, desc = "Step Back", },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue", },
    { "<leader>dd", function() require("dap").disconnect() end, desc = "Disconnect", },
    { "<leader>de", function() require("dapui").eval() end, mode = {"n", "v"}, desc = "Evaluate", },
    { "<leader>dg", function() require("dap").session() end, desc = "Get Session", },
    { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover Variables", },
    { "<leader>dS", function() require("dap.ui.widgets").scopes() end, desc = "Scopes", },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into", },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step Over", },
    { "<leader>dp", function() require("dap").pause.toggle() end, desc = "Pause", },
    { "<leader>dq", function() require("dap").close() end, desc = "Quit", },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL", },
    { "<leader>ds", function() require("dap").continue() end, desc = "Start", },
    { "<leader>dt", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
    { "<leader>dx", function() require("dap").terminate() end, desc = "Terminate", },
    { "<leader>du", function() require("dap").step_out() end, desc = "Step Out", },
    -- Custom
    { "<leader>dk", function() require("dap").up() end, desc = "Go Up 1 Stack Frame", },
    { "<leader>dj", function() require("dap").down() end, desc = "Go Down 1 Stack Frame", },
    { "<F1>", function() require("dap.ui.widgets").hover() end, desc = "Hover Variables", },
    { "<S-F4>", function() require("dapui").eval() end, mode = {"n", "v"}, desc = "Evaluate", },
    { "<F5>", function() require("dap").continue() end, desc = "Continue", },
    { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
    { "<F10>", function() require("dap").step_over() end, desc = "Step Over", },
    { "<F11>", function() require("dap").step_into() end, desc = "Step In", },
    { "<S-F11>", function() require("dap").step_out() end, desc = "Step Out", },
    { "<M-d>", function() require("dap.ui.widgets").hover() end, desc = "Hover Variables", },
  },
  opts = {
    setup = {
      osv = function(_, _) end,
    },
  },
  config = function(plugin, opts)
    require("nvim-dap-virtual-text").setup({ commented = true, })
    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup({
      layouts = {
        {
          elements = {
            {
              id = "breakpoints",
              size = 0.10
            },
            {
              id = "stacks",
              size = 0.30
            },
            {
              id = "scopes",
              size = 0.30
            },
            {
              id = "watches",
              size = 0.30
            }
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            {
              id = "console",
              size = 0.2,
            },
            {
              id = "repl",
              size = 0.8,
            },
          },
          position = "bottom",
          size = 10,
        }
      },
    })
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    vim.fn.sign_define("DapBreakpoint", {text="●", texthl="DiagnosticSignError", linehl="", numhl=""})
    vim.fn.sign_define("DapBreakpointCondition", {text="🯄", texthl="DiagnosticSignError", linehl="", numhl=""})
    vim.fn.sign_define("DapBreakpointRejected", {text="ⓧ", texthl="DiagnosticSignWarn", linehl="", numhl=""})
    vim.fn.sign_define("DapLogPoint", {text="✎", texthl="DiagnosticSignInfo", linehl="", numhl=""})
    vim.fn.sign_define("DapStopped", {text="→", texthl="DiagnosticSignWarn", linehl="DiagnosticSignError", numhl="DiagnosticSignError"})

    -- Keep DAP out of BufferLine
    vim.api.nvim_create_autocmd({"BufWinEnter"}, {
      pattern = {
        "*DAP *",
      },
      callback = function()
        vim.cmd("setl nobuflisted")
      end,
    })

    -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
    dap.adapters.lldb = {
      type = "executable",
      command = "lldb-dap",
      name = "lldb",
    }
    local lldb = {
      name = "Launch lldb",
      type = "lldb", -- matches the adapter
      request = "launch", -- could also attach to a currently running process
      program = function()
        local exe = vim.fn.getcwd() .. "/build/bin"

        -- Attempt to get the current Rust target
        if vim.fn.filereadable("Cargo.toml") then
          local basepath = string.match(vim.fn.getcwd(), "[/\\]([^/\\]*)$")
          exe = vim.fn.getcwd() .. "/target/debug/" .. basepath
        end

        -- Attempt to get the current CMake Tools launch target
        local has_cmake, cmake = pcall(require, "cmake-tools")
        if has_cmake then
          local tgt = cmake.get_config():get_launch_target()
          if tgt.data ~= nil then
            exe = tgt.data
          end
        end

        return vim.fn.input(
          "Path to executable: ",
          exe,
          "file"
        )
      end,
      cwd = "${workspaceFolder}",
      env = {
        "NOCOLOR=1",
      },
      stopOnEntry = false,
      args = {},
      runInTerminal = false,
    }

    -- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
    dap.adapters.cppdbg = {
      id = "cppdbg",
      type = "executable",
      -- command = "/home/vagrant/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
      command = vim.fn.expand("$HOME/.local/share/nvim/mason/bin/OpenDebugAD7"),
    }
    local cppdbg = {
      {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        setupCommands = {
          {
             text = '-enable-pretty-printing',
             description =  'enable pretty printing',
             ignoreFailures = false
          },
        },
        -- stopAtEntry = true,
      },
      -- {
      --   name = 'Attach to gdbserver :1234',
      --   type = 'cppdbg',
      --   request = 'launch',
      --   MIMode = 'gdb',
      --   miDebuggerServerAddress = 'localhost:1234',
      --   miDebuggerPath = '/usr/bin/gdb',
      --   cwd = '${workspaceFolder}',
      --   setupCommands = {
      --     {
      --        text = '-enable-pretty-printing',
      --        description =  'enable pretty printing',
      --        ignoreFailures = false
      --     },
      --   },
      --   program = function()
      --     return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      --   end,
      -- },
      lldb
    }

    dap.configurations.cpp = cppdbg
    -- dap.configurations.cpp = {
    --   cppdbg, lldb
    -- }
    dap.configurations.c = dap.configurations.cpp

    -- dap.configurations.rust = lldb

    -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python
    local dap = require("dap")
    dap.adapters.python = function(cb, config)
      if config.request == "attach" then
        ---@diagnostic disable-next-line: undefined-field
        local port = (config.connect or config).port
        ---@diagnostic disable-next-line: undefined-field
        local host = (config.connect or config).host or "127.0.0.1"
        cb({
          type = "server",
          port = assert(port, "`connect.port` is required for a python `attach` configuration"),
          host = host,
          options = {
            source_filetype = "python",
          },
        })
      else
        cb({
          type = "executable",
          -- command =  vim.fn.expand("$HOME/.local/opt/debugpy/bin/python"),
          command = "python",
          args = { "-m", "debugpy.adapter" },
          options = {
            source_filetype = "python",
          },
        })
      end
    end
    dap.configurations.python = {
      {
        -- The first three options are required by nvim-dap
        type = "python"; -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = "launch";
        name = "Launch file";

        -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-setting
        program = "${file}"; -- This configuration will launch the current file if used.
        pythonPath = function()
          -- "debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself."
          -- NOTE: This does not seem to work with the vscode launch.json extension
          local cwd = vim.fn.getcwd()
          if os.getenv("VIRTUAL_ENV") then
            return os.getenv("VIRTUAL_ENV") .. "/bin/python"
          elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
            return cwd .. "/.venv/bin/python"
          elseif vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
            return cwd .. "/venv/bin/python"
          else
            return "python"
          end
        end;
      }
    }

    -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#dotnet
    dap.adapters.coreclr = {
      type = "executable",
      command = "netcoredbg",
      args = { "--interpreter=vscode" }
    }
    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
          local debugdir = vim.fn.getcwd() .. '/bin/Debug/'
          local basepath = string.match(vim.fn.getcwd(), "[/\\]([^/\\]*)$")
          local dll = vim.fn.globpath(debugdir, 'net*/' .. basepath .. '.dll')
          return vim.fn.input('Path to dll', dll, 'file')
        end,
      },
    }

    -- CMake https://github.com/mfussenegger/nvim-dap/pull/992
    local dap = require("dap")
    dap.adapters.cmake = {
      type = "pipe",
      pipe = "${pipe}",
      executable = {
        command = "cmake",
        args = {"--debugger", "--debugger-pipe", "${pipe}"}
      }
    }
    dap.configurations.cmake = {
      {
        name = "Build",
        type = "cmake",
        request = "launch",
      }
    }

    require("dap.ext.vscode").load_launchjs()
    -- set up debugger
    for k, _ in pairs(opts.setup) do
      opts.setup[k](plugin, opts)
    end

    -- Keep DAP out of BufferLine
    vim.api.nvim_create_autocmd({"WinNew", "WinLeave"},
      {
        pattern = {
          "*DAP*",
          "*dap*",
        },
        callback = function(args)
          vim.api.nvim_buf_set_option(args.buf, "buflisted", false)
        end,
      }
    )
  end,
}
