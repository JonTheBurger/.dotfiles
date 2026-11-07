vim.filetype.add({
  pattern = {
    [".*code%-workspace"] = { "json", { priority = 10 } },
  }
})
