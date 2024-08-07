-- https://github.com/p00f/clangd_extensions.nvim
return {
  "p00f/clangd_extensions.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
  },
  keys = {
    {
      "<leader>ct",
      "<CMD>ClangdTypeHierarchy<CR>",
      desc="Clangd Type Hierarchy",
    },
  },
  ft = {
    "c",
    "cpp",
  },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    require("clangd_extensions").setup({
      capabilities = capabilities,
    })
    vim.api.nvim_create_user_command("A", "ClangdSwitchSourceHeader", {})
    -- local ok, wf = pcall(require, "vim.lsp._watchfiles")
    -- if ok then
    --    -- disable lsp watcher. Too slow on linux
    --    wf._watchfunc = function()
    --      return function() end
    --    end
    -- end
  end,
}

