--https://github.com/sopa0/telescope-makefilelvim.plugins 
return {
  "sopa0/telescope-makefile",
  dependencies = {
    "akinsho/nvim-toggleterm.lua",
  },
  event = "VeryLazy",
  config = function()
    require("telescope-makefile").setup({
      default_target = nil,
    })
    require("telescope").load_extension("make")
    vim.api.nvim_create_user_command(
      "M",
      function()
        vim.cmd(":Telescope make")
      end,
      { desc = "Run make" }
    )
  end,
}
