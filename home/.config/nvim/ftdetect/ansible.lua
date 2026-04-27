vim.filetype.add({
  pattern = {
    [".*ansible.*/.*%.yml"] = { "yaml.ansible", { priority = 10 } },
    [".*ansible.*/.*%.yaml"] = { "yaml.ansible", { priority = 10 } },
  },
})
