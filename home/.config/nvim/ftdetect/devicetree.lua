vim.filetype.add({
  pattern = {
    [".*dtsi?$"] = { "dts", { priority = 10 } },
  },
})
