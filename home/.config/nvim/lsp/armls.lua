---@type vim.lsp.Config
return {
  cmd = { "armls" },
  filetypes = { "asm" },
  settings = {
    armls = {
      diagnostics = {
        enable = true,
        disableCategories = {
          "invalidOperand",
          "tooManyOperands",
          "tooFewOperands",
        },
      },
    },
  },
}
