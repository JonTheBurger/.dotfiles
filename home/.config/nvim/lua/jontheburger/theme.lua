-- Colorscheme
-- vim.cmd("colorscheme molokai")
vim.cmd("colorscheme space-vim-dark")

-- Diagnostics
local signs = {
  Error = "✘",
  Warn = "▲",
  Hint = "⚑",
  Info = "»",
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
vim.cmd([[highlight DiagnosticError guifg=DarkRed]])
vim.cmd([[highlight DiagnosticWarn guifg=DarkYellow]])
vim.cmd([[highlight DiagnosticHint guifg=LightBlue]])
vim.cmd([[highlight DiagnosticInfo guifg=Gray]])

-- SpellCheck
vim.cmd([[highlight clear SpellBad]])
vim.cmd([[highlight SpellBad cterm=underline]])
vim.cmd([[highlight SpellBad gui=undercurl]])

-- Whitespace
--vim.cmd([[highlight NonText guifg=DarkGray]])
--vim.cmd([[highlight SpecialKey guifg=DarkGray]])

-- Transparency
--vim.cmd([[highlight Normal guibg=none]])
