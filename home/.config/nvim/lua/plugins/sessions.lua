return {
  "folke/persistence.nvim",
  enabled = not vim.g.vscode,
  event = "BufReadPre",
  opts = { branch = true },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceSavePre",
      callback = function()
        require("config.fn").buf.close_widgets()
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceSavePost",
      callback = function()
        require("config.fn").bkpt.save()
      end,
    })
    -- vim.api.nvim_create_autocmd("User", {
    --   pattern = "PersistenceLoadPre",
    -- })
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceLoadPost",
      callback = function()
        require("config.fn").bkpt.load()
      end,
    })
  end,
}
