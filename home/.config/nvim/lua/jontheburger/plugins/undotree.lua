-- https://github.com/mbbill/undotree
return {
  "mbbill/undotree",
  event = "BufEnter",
  keys = {
    { "<leader>u", "<CMD>UndotreeToggle<CR>", desc = "Undo Tree Toggle" }
  },
  init = function()
    vim.g.undotree_WindowLayout = 4
  end,
}
