--- @class UserData
--- @field explorer bool? true if the file explorer was open
--- @field tests bool? true if the test explorer was open
--- @field symbols bool? true if the test explorer was open
--- @field diagnostics bool? true if the test explorer was open
--- @field breakpoints Any? true if the file explorer was open

-- print(vim.inspect(require('dap.breakpoints').get()))
-- TODO: undotree
-- TODO: breakpoints
-- TODO: Code review
-- TODO: remove $NVIM_APPNAME

return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = { branch = true, },
  init = function()
    -- vim.api.nvim_create_autocmd("User", {
    --   pattern = "PersistenceLoadPre",
    -- })
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceLoadPost",
      callback = function()
        ---@type UserData
        local user_data = {}
        local json = require("config.util").session_file()
        if json:exists() then
          vim.fn.json_decode(json:read())
        end

        if user_data.breakpoints ~= nil then

          -- require("dap.breakpoints").set(bufnr="", lnum="", opts={})
        end
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceSavePre",
      callback = function()
        require("config.util").unwanted_buf_del()
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceSavePost",
      callback = function()
        local bkpts = require("config.util").get_bkpts()
        ---@type UserData
        local user_data = {
          breakpoints = bkpts,
        }
        require("config.util").session_file():write(vim.fn.json_encode(user_data), "w")
      end,
    })
  end,
}
