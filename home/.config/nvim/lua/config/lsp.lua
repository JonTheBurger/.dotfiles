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

vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
  if result.type == vim.lsp.protocol.MessageType.Info then
    return  -- ignore info messages
  end
  vim.notify(result.message, vim.log.levels[result.type] or vim.log.levels.INFO)
end

vim.lsp.enable("ansible")
vim.lsp.enable("bitbake")
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
