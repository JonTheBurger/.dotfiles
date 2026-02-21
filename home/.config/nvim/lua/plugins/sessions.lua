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
        fn.bkpt.save()
        -- Dap EXE
        local linefile = fn.fs.session_file("dap_executable.txt")
        linefile:write(fn.gbl.dap_executable, "w")
      end,
    })
    -- vim.api.nvim_create_autocmd("User", {
    --   pattern = "PersistenceLoadPre",
    -- })
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceLoadPost",
      callback = function()
        local fn = require("config.fn")
        fn.bkpt.load()
        -- Dap EXE
        local linefile = fn.fs.session_file("dap_executable.txt")
        if linefile:exists() then
          fn.gbl.dap_executable = fn.str.trim(linefile:read())
        end
      end,
    })
  end,
}
