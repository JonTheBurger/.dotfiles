-- https://github.com/simrat39/symbols-outline.nvim
return {
  "simrat39/symbols-outline.nvim",
  event = "VeryLazy",
  config = function()
    require("symbols-outline").setup()
    -- This plugin can't handle keys
    vim.keymap.set('n', '<leader>y', '<CMD>SymbolsOutline<CR>')
  end,
  -- keys = {
  --   "<leader>y",
  --   function()
  --     require("symbols-outline").toggle_outline()
  --   end,
  --   mode = "n",
  --   desc="Toggle Symbol Outline",
  -- },
}
-- TODO:
--local opts = {
--  fold_markers = { '', '' },
--  lsp_blacklist = {},
--  symbol_blacklist = {},
--  symbols = {
--    File = { icon = "", hl = "@text.uri" },
--    Module = { icon = "", hl = "@namespace" },
--    Namespace = { icon = "", hl = "@namespace" },
--    Package = { icon = "", hl = "@namespace" },
--    Class = { icon = "𝓒", hl = "@type" },
--    Method = { icon = "ƒ", hl = "@method" },
--    Property = { icon = "", hl = "@method" },
--    Field = { icon = "", hl = "@field" },
--    Constructor = { icon = "", hl = "@constructor" },
--    Enum = { icon = "ℰ", hl = "@type" },
--    Interface = { icon = "ﰮ", hl = "@type" },
--    Function = { icon = "", hl = "@function" },
--    Variable = { icon = "", hl = "@constant" },
--    Constant = { icon = "", hl = "@constant" },
--    String = { icon = "𝓐", hl = "@string" },
--    Number = { icon = "#", hl = "@number" },
--    Boolean = { icon = "⊨", hl = "@boolean" },
--    Array = { icon = "", hl = "@constant" },
--    Object = { icon = "⦿", hl = "@type" },
--    Key = { icon = "🔐", hl = "@type" },
--    Null = { icon = "NULL", hl = "@type" },
--    EnumMember = { icon = "", hl = "@field" },
--    Struct = { icon = "𝓢", hl = "@type" },
--    Event = { icon = "🗲", hl = "@type" },
--    Operator = { icon = "+", hl = "@operator" },
--    TypeParameter = { icon = "𝙏", hl = "@parameter" },
--    Component = { icon = "", hl = "@function" },
--    Fragment = { icon = "", hl = "@constant" },
--  },
--}
--require("symbols-outline").setup()
--vim.keymap.set('n', '<leader>s', ':SymbolsOutline<CR>')

