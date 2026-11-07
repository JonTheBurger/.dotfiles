codes = true
globals = {
  "Snacks",
  "assert",
  "describe",
  "it",
  "vim",
}
exclude_files = {
  "lua_modules/",
}
ignore = {
  "631", -- Line too long - this also flags comments, and we have a formatter.
}
