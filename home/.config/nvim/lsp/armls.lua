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
