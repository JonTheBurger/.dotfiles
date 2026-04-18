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
local DAP_VIEW = true

local pick_args = function()
  return coroutine.create(function(coro)
    vim.ui.input({
      prompt = "Arguments: ",
      default = require("config.fn").gbl.dap_exe_args,
      completion = "file",
    }, function(choice)
      if choice then
        require("config.fn").gbl.dap_exe_args = choice
      else
        choice = ""
      end
      coroutine.resume(coro, vim.split(choice, " +"))
    end)
  end)
end

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
      { "<leader>dN",  function() require("osv").launch({ port = 8086, log=true }) end,             desc = "Launch nvim Server",     noremap = true, },
      { "<leader>dj",  function() require("dap").up() end,                                          desc = "Go Up 1 Stack Frame", },
      { "<leader>dk",  function() require("dap").down() end,                                        desc = "Go Down 1 Stack Frame", },
      { "<F4>",        function() require("dap").set_exception_breakpoints({ "Warning", "Error", "Exception" }) end, desc = "Set Exception Breakpoints", },
      { "<F5>",        function() require("dap").continue() end,                                    desc = "Continue", },
      { "<F6>",        function() require("dap").run_to_cursor() end,                               desc = "Run to Cursor", },
      { "<F8>",        function() require("dap").set_breakpoint(vim.fn.input "[Condition] > ") end, desc = "Conditional Breakpoint", },
      { "<F9>",        function() require("dap").toggle_breakpoint() end,                           desc = "Toggle Breakpoint", },
      { "<F10>",       function() require("dap").step_over() end,                                   desc = "Step Over", },
      { "<F11>",       function() require("dap").step_into() end,                                   desc = "Step In", },
      { "<F12>",       function() require("dap").step_out() end,                                    desc = "Step Out", },
      -- { "<leader>db",  function() require("dap").step_back() end,                                   desc = "Step Back", },
      -- { "<leader>dd",  function() require("dap").disconnect() require("dapui").close() end,         desc = "Disconnect", },
      -- { "<leader>de",  function() require("dapui").eval() end,                                      desc = "Evaluate",               mode = { "n", "v" }, },
      -- { "<leader>dg",  function() require("dap").session() end,                                     desc = "Get Session", },
      -- { "<leader>dh",  function() require("dap.ui.widgets").hover() end,                            desc = "Hover Variables", },
      -- { "<leader>dS",  function() require("dap.ui.widgets").scopes() end,                           desc = "Scopes", },
      -- { "<leader>dp",  function() require("dap").pause.toggle() end,                                desc = "Pause", },
      -- { "<leader>dq",  function() require("dap").close() end,                                       desc = "Quit", },
      -- { "<leader>dr",  function() require("dap").repl.toggle() end,                                 desc = "Toggle REPL", },
      -- { "<leader>dE",  function() require("dapui").eval(vim.fn.input "[Expression] > ") end,        desc = "Evaluate Input", },
    },
    -- stylua: ignore end
    opts = {
      -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
      adapters = {
        gdb = {
          id = "gdb",
          name = "gdb",
          type = "executable",
          command = "gdb",
          args = { "--quiet", "--interpreter=dap" },
        },
        cppdbg = {
          id = "cppdbg",
          name = "cppdbg",
          type = "executable",
          command = tostring(require("config.fn").fs.find_vscode_binary("ms-vscode.cpptools", "OpenDebugAD7")),
        },
        lldb = {
          id = "lldb",
          name = "lldb",
          type = "executable",
          command = "/usr/bin/lldb-dap",
        },
        cmake = {
          id = "cmake",
          name = "cmake",
          type = "pipe",
          -- vagrant    43759  0.0  0.0 118256 19892 pts/10   Sl+  11:59   0:00 /usr/bin/cmake -DCMAKE_BUILD_TYPE:STRING=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_C_COMPILER:FILEPATH=/usr/bin/gcc -DCMAKE_CXX_COMPILER:FILEPATH=/usr/bin/g++ --no-warn-unused-cli -S /home/vagrant/Projects/engprod/metl/tools/msa-cmake-modules -B /home/vagrant/Projects/engprod/metl/tools/msa-cmake-modules/build -G Ninja --debugger --debugger-pipe /tmp/cmake-debugger-pipe-9a4ad188-f3b4-4810-af4b-396742966126
          -- cwd = require("config.fn").util.select_cmake_cwd,
          executable = {
            command = "cmake",
            args = require("config.fn").gbl.cmake_args,
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
        gdb = {
          name = "gdb: launch",
          type = "gdb",
          request = "launch",
          program = require("config.fn").util.select_cxx_executable,
          cwd = "${workspaceFolder}",
          env = { ["NOCOLOR"] = "1" },
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
        -- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
        cppdbg = {
          name = "cppdbg: launch",
          type = "cppdbg",
          request = "launch",
          program = require("config.fn").util.select_cxx_executable,
          cwd = "${workspaceFolder}",
          env = { ["NOCOLOR"] = "1" },
          stopOnEntry = false,
          -- args = {},
          args = pick_args,
          runInTerminal = false,
          setupCommands = {
            {
              text = "-enable-pretty-printing",
              description = "enable pretty printing",
              ignoreFailures = false,
            },
          },
        },
        gdbserver = {
          name = "gdb: server",
          type = "cppdbg",
          request = "launch",
          cwd = "${workspaceFolder}",
          program = require("config.fn").util.select_cxx_executable,
          stopAtEntry = false,
          MIMode = "gdb",
          miDebuggerServerAddress = "localhost:2331",
          miDebuggerPath = "/usr/bin/gdb-multiarch",
          serverLaunchTimeout = 5000,
          postRemoteConnectCommands = {
            {
              text = "monitor reset",
              ignoreFailures = false
            },
            {
              text = "load",
              ignoreFailures = false
            },
          },
        },
        lldb = {
          name = "lldb: launch",
          type = "lldb", -- matches the adapter
          request = "launch", -- could also attach to a currently running process
          program = require("config.fn").util.select_cxx_executable,
          cwd = "${workspaceFolder}",
          env = { ["NOCOLOR"] = "1" },
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
        -- CMake https://github.com/mfussenegger/nvim-dap/pull/992
        cmake = {
          name = "cmake: debug",
          type = "cmake",
          -- cwd = require("config.fn").util.select_cmake_cwd,
          request = "launch",
          args = require("config.fn").util.select_cmake_args,
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
          opts.launchers.cppdbg,
          opts.launchers.gdbserver,
          opts.launchers.gdb,
          opts.launchers.lldb,
        },
        cpp = {
          opts.launchers.cppdbg,
          opts.launchers.gdbserver,
          opts.launchers.gdb,
          opts.launchers.lldb,
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
    "igorlfs/nvim-dap-view",
    enabled = DAP_VIEW and not vim.g.vscode,
    lazy = false,
    version = "1.*",
    keys = {
      { "<leader>dw", "<cmd>DapViewWatch<CR>", desc = "Add symbol under cursor to watches", },
      { "_d",         function() require("dap-view").toggle() end, desc = "Toggle UI", },
      { "<leader>dx", function() require("dap").terminate() require("dap-view").close() end, desc = "Terminate", },
      { "<leader>ds", function() require("dap-view").show_view("scopes") end, desc = "Show view scopes", },
      { "<leader>dS", function() require("dap-view").jump_to_view("scopes") end, desc = "Jump view scopes", },
      { "<leader>db", function() require("dap-view").show_view("breakpoints") end, desc = "Show view breakpoints", },
      { "<leader>dB", function() require("dap-view").jump_to_view("breakpoints") end, desc = "Jump view breakpoints", },
      { "<leader>de", function() require("dap-view").show_view("exceptions") end, desc = "Show view exceptions", },
      { "<leader>dE", function() require("dap-view").jump_to_view("exceptions") end, desc = "Jump view exceptions", },
      { "<leader>dW", function() require("dap-view").jump_to_view("watches") end, desc = "Jump view watches", },
      { "<leader>dt", function() require("dap-view").show_view("threads") end, desc = "Show view threads", },
      { "<leader>dT", function() require("dap-view").jump_to_view("threads") end, desc = "Jump view threads", },
      { "<leader>dr", function() require("dap-view").show_view("repl") end, desc = "Show view repl", },
      { "<leader>dR", function() require("dap-view").jump_to_view("repl") end, desc = "Jump view repl", },
      { "<leader>dc", function() require("dap-view").show_view("console") end, desc = "Show view console", },
      { "<leader>dC", function() require("dap-view").jump_to_view("console") end, desc = "Jump view console", },
    },
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {
      winbar = {
        show = true,
        sections = { "console", "watches", "scopes", "breakpoints", "threads", "repl", "exceptions", "disassembly", },
        default_section = "console",
        show_keymap_hints = true,
        separators = nil,
        base_sections = {
          breakpoints = { label = " Bkp", keymap = "B" },
          scopes = { label = "󱡠 Sco", keymap = "S" },
          exceptions = { label = "󱐋 Exc", keymap = "E" },
          watches = { label = " Wtch", keymap = "W" },
          threads = { label = "  Thrd", keymap = "T" },
          repl = { label = "  REPL", keymap = "R" },
          sessions = { label = "  Sess", keymap = "K" },
          console = { label = " Con", keymap = "C" },
        },
        -- https://igorlfs.github.io/nvim-dap-view/custom-views
        custom_sections = {},
        controls = {
          enabled = true,
          position = "right",
          buttons = {
            "play",
            -- "step_into",
            -- "step_over",
            "step_out",
            "step_back",
            "run_last",
            "terminate",
            "disconnect",
          },
          custom_buttons = {},
        },
      },
      windows = {
        size = 0.25,
        position = "below",
        terminal = {
          size = 0.5,
          position = "left",
          -- List of debug adapters for which the terminal should be ALWAYS hidden
          hide = {},
        },
      },
      help = {
        border = nil,
      },
      render = {
        -- https://igorlfs.github.io/nvim-dap-view/custom-formatting
        threads = {
          format = function(name, lnum, path)
            local value = name:gsub("%(anonymous namespace%)", "?")
            value = value:gsub("::v%d::", "::")
            return {
              { text = value },
              { text = path, hl = "FileName",  separator = ":" },
              { text = lnum, hl = "LineNumber" },
            }
          end,
        },
      },
      virtual_text = {
        enabled = true,
        format = function(variable, _, _)
          local value = variable.value:gsub("%s+", " ") -- strip new lines
          value = value:gsub("%(anonymous namespace%)", "?")
          value = value:gsub("::v%d::", "::")
          return " " .. value
        end,
      },
      switchbuf = "usetab,uselast",
      auto_toggle = false,
      follow_tab = false,
    },
    config = function(_, opts)
      local dapview = require("dap-view")
      dapview.setup(opts)

      local dap = require("dap")
      dap.listeners.after.event_initialized["dapview_config"] = function()
        dapview.open()
      end
      dap.listeners.before.event_terminated["dapview_config"] = function()
        dapview.close()
      end
      dap.listeners.before.event_exited["dapview_config"] = function()
        dapview.close()
      end
      dap.listeners.after.event_stopped["center_view"] = function()
        vim.cmd("normal! zz")
      end

      vim.api.nvim_create_autocmd({ "FileType" }, {
        desc = "Buffer local keymaps for DAP View",
        pattern = { "dap-view", "dap-view-term", "dap-repl", "dap-disassembly" },
        callback = function()
          vim.keymap.set("n", "<", function()
            require("dap-view").navigate({ count=-1, wrap=true, type = "views", })
          end, { buf = 0 })
          vim.keymap.set("n", ">", function()
            require("dap-view").navigate({ count=1, wrap=true, type = "views", })
          end, { buf = 0 })
          vim.keymap.set("n", "?", "g?", { buf = 0, remap = true })
        end,
      })
    end,
  },
  {
    url = "https://codeberg.org/Jorenar/nvim-dap-disasm.git",
    dependencies = "igorlfs/nvim-dap-view",
    config = true,
  },
  {
    -- https://github.com/rcarriga/nvim-dap-ui
    "rcarriga/nvim-dap-ui",
    enabled = not DAP_VIEW and not vim.g.vscode,
    lazy = false,
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
            { id = "stacks", size = 0.30 },
            { id = "scopes", size = 0.30 },
            { id = "watches", size = 0.30 },
          },
        },
        {
          position = "bottom",
          size = 10,
          elements = {
            { id = "console", size = 0.20 },
            { id = "repl", size = 0.80 },
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
      dap.listeners.after.event_stopped["center_view"] = function()
        vim.cmd("normal! zz")
      end
    end,
    keys = {
      { "<leader>dw",  function() require("dapui").elements.watches.add() end, desc = "Add symbol under cursor to watches", },
      { "<leader>dx",  function() require("dap").terminate() require("dapui").close() end,          desc = "Terminate", },
      { "_d",          function() require("dapui").toggle() end,                                    desc = "Toggle UI", },
    },
  },
  {
    -- https://github.com/theHamsta/nvim-dap-virtual-text
    "theHamsta/nvim-dap-virtual-text",
    enabled = not DAP_VIEW and not vim.g.vscode,
    opts = {
      display_callback = function(variable, buf, stackframe, node, options)
        local value = variable.value:gsub("%s+", " ") -- strip new lines
        value = value:gsub("%(anonymous namespace%)", "?")
        value = value:gsub("::v%d::", "::")
        if options.virt_text_pos == "inline" then
          return " = " .. value
        else
          return variable.name .. " = " .. value
        end
      end,
    },
  },
  {
    -- https://github.com/stevearc/profile.nvim
    "stevearc/profile.nvim",
    init = function ()
      local should_profile = os.getenv("NVIM_PROFILE")
      if should_profile then
        require("profile").instrument_autocmds()
        if should_profile:lower():match("^start") then
          require("profile").start("*")
        else
          require("profile").instrument("*")
        end
      end

      local function toggle_profile()
        local prof = require("profile")
        if prof.is_recording() then
          prof.stop()
          vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
            if filename then
              prof.export(filename)
              vim.notify(string.format("Wrote %s", filename))
            end
          end)
        else
          prof.start("*")
        end
      end
      vim.api.nvim_create_user_command("Profile", toggle_profile, { desc = "Profile NeoVim" })
    end
  }
}
