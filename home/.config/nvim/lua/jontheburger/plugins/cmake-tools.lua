-- https://github.com/Civitasv/cmake-tools.nvim/blob/master/docs/all_commands.md
return {
  "Civitasv/cmake-tools.nvim",
  dependencies = {
    { "mfussenegger/nvim-dap", },
    { "nvim-lua/plenary.nvim", },
    { "nvim-telescope/telescope.nvim", },
  },
  ft = { "cmake", "c", "cpp" },
  -- https://github.com/Civitasv/cmake-tools.nvim/blob/master/lua/telescope/_extensions/cmake_tools.lua
  keys = {
    { "<F7>", "<CMD>CMakeBuild<CR>", desc="CMake Build", },
    { "<leader>cmb", "<CMD>CMakeBuild<CR>", desc="CMake Build", },
    { "<leader>cmt", "<CMD>CMakeSelectBuildTarget<CR>", desc="CMake Launch Target", },
    { "<leader>cmT", "<CMD>CMakeSelectLaunchTarget<CR>", desc="CMake Launch Target", },
    { "<leader>cmd", "<CMD>CMakeDebug<CR>", desc="CMake Debug", },
    { "<leader>cmr", "<CMD>CMakeRun<CR>", desc="CMake Run", },
  },
}
