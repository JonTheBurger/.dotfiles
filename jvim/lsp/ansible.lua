vim.filetype.add({
  pattern = {
    [ ".*ansible.*/.*.yml" ]  = "yaml.ansible",
    [ ".*ansible.*/.*.yaml" ] = "yaml.ansible",
  },
})
return {
  cmd = { "ansible-language-server", },
  filetypes = { "yaml.ansible", },
}
