-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--   desc = "Ruff",
--   pattern = { "*.py" },
--   callback = function()
--     vim.lsp.buf.code_action({
--       context = { only = { "source.organizeImports" } }, -- "source.fixAll"
--       apply = true,
--     })
--     vim.wait(100)
--   end,
-- })
return {
  cmd = { "ruff-lsp", },
  filetypes = { "python", },
}
