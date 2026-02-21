vim.filetype.add({
  pattern = {
    [".*ansible.*/.*%.yml"]  = { "yaml.ansible", { priority = 10 } },
    [".*ansible.*/.*%.yaml"] = { "yaml.ansible", { priority = 10 } },
  },
})

vim.filetype.add({
  pattern = {
    [".*conf/.*%.conf"] = { "bitbake", { priority = 10 } },
  },
})

vim.filetype.add({
  pattern = {
    [".*dtsi?$"]  = { "dts", { priority = 10 } },
  },
})

vim.diagnostic.config({
    float = {
        border = "rounded",
    },
})
local hover = vim.lsp.buf.hover
vim.lsp.buf.hover = function()
  return hover({
    wrap = false,
    max_width = 100,
    max_height = 40,
    border = "rounded",
  })
end

vim.lsp.enable("ansible")
vim.lsp.enable("bitbake")
vim.lsp.enable("clangd")
-- vim.lsp.enable("dts")
vim.lsp.enable("harper")
vim.lsp.enable("json")
vim.lsp.enable("lua")
vim.lsp.enable("md")
vim.lsp.enable("neocmakelsp")
vim.lsp.enable("nixd")
-- vim.lsp.enable("python")
-- vim.lsp.enable("pyrefly")
vim.lsp.enable("qml")
vim.lsp.enable("ruff")
vim.lsp.enable("sh")
vim.lsp.enable("slint")
vim.lsp.enable("sonarlint")
vim.lsp.enable("toml")
vim.lsp.enable("ty")
vim.lsp.enable("typescript")
vim.lsp.enable("vale")
vim.lsp.enable("yaml")
