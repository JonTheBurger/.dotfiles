return {
  {
    -- https://github.com/stevearc/overseer.nvim
    "stevearc/overseer.nvim",
    enabled = not vim.g.vscode,
    -- version = "<2.0.0",
    keys = {
      { "<leader>bx", "<cmd>OverseerRun<CR>",    desc = "Execute Task" },
      { "<leader>bo", "<cmd>OverseerToggle<CR>", desc = "Task Output" },
      { "<leader>O",  "<cmd>OverseerToggle<CR>", desc = "Task Output" },
      { "_o",  "<cmd>OverseerToggle<CR>", desc = "Task Output" },
    },
    ---@type overseer.Config
    opts = {
      -- templates = { "make", "vscode", "cargo", "just", "user.run_script", },
      templates = { "builtin", "user.run_script", },
      task_list = {
        max_width = { 100, 0.4 },
        min_width = { 30, 0.2 },
        max_height = { 20, 0.2 },
        keymaps = {
          ["<C-h>"] = false,
          ["<C-j>"] = false,
          ["<C-k>"] = false,
          ["<C-l>"] = false,
          ["<C-Left>"] = "DecreaseDetail",
          ["<C-Down>"] = "ScrollOutputDown",
          ["<C-Up>"] = "ScrollOutputUp",
          ["<C-Right>"] = "IncreaseDetail",
        },
      },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)
      -- https://github.com/stevearc/overseer.nvim/blob/master/doc/reference.md#add_template_hookopts-hook
      overseer.add_template_hook(
        { name = "^make.*", },
        function(task_defn, util)
          util.add_component(task_defn, { "default" })
          util.add_component(task_defn, { "unique" })
          util.add_component(task_defn, { "on_output_parse", problem_matcher = "$gcc" })
          util.add_component(task_defn, { "on_result_diagnostics", remove_on_restart=true })
          util.add_component(task_defn, { "on_result_diagnostics_trouble" })
          util.add_component(task_defn, { "on_complete_dispose" })
        end)

      -- https://github.com/stevearc/overseer.nvim/blob/master/doc/tutorials.md#run-a-file-on-save
      vim.api.nvim_create_user_command("Rerun", function()
        local overseer = require("overseer")
        overseer.run_template({ name = "run script" }, function(task)
          if task then
            task:add_component({ "restart_on_save", paths = {vim.fn.expand("%:p")} })
            local main_win = vim.api.nvim_get_current_win()
            overseer.run_action(task, "open hsplit")
            vim.api.nvim_set_current_win(main_win)
          else
            vim.notify("Rerun not supported for filetype " .. vim.bo.filetype, vim.log.levels.ERROR)
          end
        end)
      end, {})
    end,
  },
  {
    -- https://github.com/Civitasv/cmake-tools.nvim/blob/master/docs/all_commands.md
    "Civitasv/cmake-tools.nvim",
    dependencies = {
      { "mfussenegger/nvim-dap" },
      { "nvim-lua/plenary.nvim" },
    },
    ft = { "cmake", "c", "cpp" },
    opts = {
      cmake_regenerate_on_save = false,
      cmake_compile_commands_options = {
        action = "lsp", -- "soft_link"
        target = vim.uv.cwd,
      },
      cmake_runner = {
        name = "overseer",
        opts = {
          ---@class overseer.TaskDefinition
          new_task_opts = {
            name = "cmake run",
            components = {
              { "default" },
              { "unique" },
            },
          },
          ---@param task overseer.TaskDefinition
          on_new_task = function(task)
            require("overseer").open({ enter = false, direction = "bottom" })
          end,
        },
      },
      cmake_executor = {
        name = "overseer",
        opts = {
          ---@class overseer.TaskDefinition
          new_task_opts = {
            name = "cmake build",
            components = {
              { "default" },
              { "unique" },
              { "on_output_parse", problem_matcher = "$gcc" },
              { "on_result_diagnostics", remove_on_restart=true },
            },
          },
          ---@param task overseer.TaskDefinition
          on_new_task = function(task)
            require("overseer").open({ enter = false, direction = "bottom" })
          end,
        },
      },
    },
    keys = {
      { "<leader>bc", "<cmd>CMakeSelectConfigurePreset<CR>", desc = "CMake Select Configure Preset" },
      { "<leader>bp", "<cmd>CMakeSelectBuildPreset<CR>", desc = "CMake Select Build Preset" },
      { "<leader>bt", "<cmd>CMakeSelectBuildTarget<CR>", desc = "CMake Launch Target" },
      { "<leader>bl", "<cmd>CMakeSelectLaunchTarget<CR>", desc = "CMake Launch Target" },
      { "<leader>bd", "<cmd>CMakeDebug<CR>", desc = "CMake Debug" },
      { "<leader>br", "<cmd>CMakeRun<CR>", desc = "CMake Run" },
      { "<leader>bb", "<cmd>CMakeBuild<CR>", desc = "CMake Build" },
    },
  },
}
