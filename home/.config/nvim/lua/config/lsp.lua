vim.filetype.add({
  pattern = {
    [".*ansible.*/.*%.yml"]  = { "yaml.ansible", { priority = 10 } },
    [".*ansible.*/.*%.yaml"] = { "yaml.ansible", { priority = 10 } },
  },
})
vim.lsp.enable("ansible")
vim.lsp.enable("cmake")
vim.lsp.enable("cxx")
vim.lsp.enable("json")
vim.lsp.enable("lua")
vim.lsp.enable("md")
vim.lsp.enable("python")
vim.lsp.enable("ruff")
vim.lsp.enable("sh")
vim.lsp.enable("slint")
vim.lsp.enable("vale")
vim.lsp.enable("yaml")
