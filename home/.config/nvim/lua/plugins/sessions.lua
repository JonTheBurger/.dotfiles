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
        local fn = require("config.fn")
        fn.fs.save_session()
      end,
    })
    -- vim.api.nvim_create_autocmd("User", {
    --   pattern = "PersistenceLoadPre",
    -- })
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceLoadPost",
      callback = function()
        local fn = require("config.fn")
        fn.fs.load_session()
      end,
    })
  end,
}
