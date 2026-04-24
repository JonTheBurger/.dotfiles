---@type vim.lsp.Config
-- vim.g.query_lint_on = {}
return {
  cmd = { "ts_query_ls" },
  filetypes = { "query" },
  root_dir = vim.fs.root(0, { ".tsqueryrc.json", "queries" }),
  settings = {
    parser_install_directories = {
      vim.fn.stdpath("data") .. "/site/parser/", -- if using nvim-treesitter default config
    },
  },
}
