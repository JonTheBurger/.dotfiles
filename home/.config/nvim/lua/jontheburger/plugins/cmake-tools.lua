-- https://github.com/Civitasv/cmake-tools.nvim/blob/master/docs/all_commands.md
return {
  "Civitasv/cmake-tools.nvim",
  dependencies = {
    { "mfussenegger/nvim-dap", }
  },
  lazy = false,
  keys = {
    { "<leader>cmb", "<CMD>CMakeBuild<CR>", desc="CMake Build", },
    { "<leader>cmt", "<CMD>CMakeSelectBuildTarget<CR>", desc="CMake Launch Target", },
    { "<leader>cmT", "<CMD>CMakeSelectLaunchTarget<CR>", desc="CMake Launch Target", },
    { "<leader>cmd", "<CMD>CMakeDebug<CR>", desc="CMake Debug", },
    { "<leader>cmr", "<CMD>CMakeRun<CR>", desc="CMake Run", },
  },
}
