codes = true
max_line_length = 120
globals = {
  "Snacks",
  "assert",
  "describe",
  "it",
  "vim",
}
exclude_files = {
  "lua/nvim-neocov/external/",
  "lua_modules/",
}
ignore = {
  "631", -- Line too long - this also flags comments, and we have a formatter.
}
