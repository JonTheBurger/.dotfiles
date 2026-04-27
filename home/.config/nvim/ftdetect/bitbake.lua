vim.filetype.add({
  pattern = {
    [".*conf/.*%.conf"] = { "bitbake", { priority = 10 } },
  },
})
