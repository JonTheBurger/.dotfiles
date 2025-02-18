return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = { branch = true },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceSavePre",
      callback = function()
        require("config.fn").unwanted_buf_del()
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceSavePost",
      callback = function()
        require("config.fn").bkpt_save()
      end,
    })
    -- vim.api.nvim_create_autocmd("User", {
    --   pattern = "PersistenceLoadPre",
    -- })
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceLoadPost",
      callback = function()
        require("config.fn").bkpt_load()
      end,
    })
  end,
}
