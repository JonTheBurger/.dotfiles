--- Crystal Theme ---
-- https://neovim.io/doc/user/api.html#nvim_set_hl()
local color = {
  RED          = "#C00000",
  RED_LIGHT    = "#FC1929",

  ORANGE_LIGHT = "#FF6600",
  ORANGE       = "#FFA200",
  ORANGE_DARK  = "#FFBE00",
  YELLOW       = "#FFE800",
  SEWAGE       = "#808000",

  GREEN_DARK   = "#2E8C00",
  GREEN        = "#55FF00",
  GREEN_LIGHT  = "#4EF278",

  BLUE         = "#0084FF",
  BLUE_LIGHT   = "#00A3CC",
  SEAFOAM      = "#0096BC",
  TURQUOISE    = "#00FFD5",

  METAL        = "#7276B4",
  PURPLE       = "#C489FF",
  PINK         = "#FF539E",

  BROWN_DARK   = "#553008",
  BROWN        = "#5D4A32",
  BROWN_LIGHT  = "#FFC66D",
  CREAM        = "#FFF7B8",

  BLACK        = "#000000",
  GRAY1        = "#161813",
  GRAY2        = "#1E201A",
  GRAY3        = "#35392D",
  GRAY4        = "#808080",
  GRAY5        = "#B2B2B6",
  WHITE        = "#CCCCCC",

  NONE         = "NONE",
}

local palette = {
  PRIMITIVE = { fg = color.BLUE_LIGHT, bold = true, },
}

-- Syntax highlight groups
local syntax = {
  Normal         = { fg = color.WHITE, bg = color.GRAY2, },
  Type           = { fg = color.TURQUOISE, },
  StorageClass   = palette.PRIMITIVE,
  Structure      = { fg = color.TURQUOISE, },
  Constant       = { fg = color.ORANGE, bold = true, },
  Character      = { fg = color.GREEN, },
  Number         = { fg = color.GREEN_LIGHT, },
  Boolean        = { fg = color.BLUE_LIGHT, },
  Float          = { fg = color.BLUE_LIGHT, },
  Comment        = { fg = color.GRAY4, },
  Conditional    = palette.PRIMITIVE,
  Keyword        = palette.PRIMITIVE,
  -- Repeat = {},
  Function       = { fg = color.PURPLE, },
  -- Identifier = {},
  String         = { fg = color.GREEN_LIGHT, },
  -- Statement = {},
  Label          = { fg = color.BROWN_DARK, },
  Operator       = { fg = color.BROWN_LIGHT, bold = true, },
  Exception      = palette.PRIMITIVE,
  PreProc        = { fg = color.PINK, },
  Include        = { fg = color.PINK, bold = true, },
  -- Define = {},
  Macro          = { fg = color.YELLOW, bold = true, },
  -- Typedef        = {},
  -- PreCondit = {},
  -- Special = {},
  -- SpecialChar = {},
  -- Tag = {},
  -- Delimiter = {},
  SpecialComment = { italic = true, },
  -- Debug = {},
  -- Underlined = {},
  -- Ignore = {},
  -- Error = {},
  -- Todo = {},
  -- Conceal = {},

  -- C
  cBlock         = { fg = color.TURQUOISE, },
  -- cStatement     xxx links to Statement
  -- cLabel         xxx links to Label
  -- cConditional   xxx links to Conditional
  -- cRepeat        xxx links to Repeat
  -- cTodo          xxx links to Todo
  -- cBadContinuation xxx links to Error
  -- cSpecial       xxx links to SpecialChar
  -- cFormat        xxx links to cSpecial
  -- cString        xxx links to String
  -- cCppString     xxx links to cString
  -- cSpaceError    xxx links to cError
  -- cCppSkip       xxx cleared
  -- cCharacter     xxx links to Character
  -- cSpecialError  xxx links to cError
  -- cSpecialCharacter xxx links to cSpecial
  -- cBadBlock      xxx cleared
  -- cCurlyError    xxx links to cError
  -- cErrInParen    xxx links to cError
  -- cCppParen      xxx cleared
  -- cErrInBracket  xxx links to cError
  -- cCppBracket    xxx cleared
  -- cBlock         xxx cleared
  -- cParenError    xxx links to cError
  -- cIncluded      xxx links to cString
  -- cCommentSkip   xxx links to cComment
  -- cCommentString xxx links to cString
  -- cComment2String xxx links to cString
  -- cCommentStartError xxx links to cError
  -- cUserLabel     xxx links to Label
  -- cBitField      xxx cleared
  -- cOctalZero     xxx links to PreProc
  -- cNumber        xxx links to Number
  -- cFloat         xxx links to Float
  -- cOctal         xxx links to Number
  -- cOctalError    xxx links to cError
  -- cNumbersCom    xxx cleared
  -- cParen         xxx cleared
  -- cBracket       xxx cleared
  -- cNumbers       xxx cleared
  -- cWrongComTail  xxx links to cError
  -- cCommentL      xxx links to cComment
  -- cCommentStart  xxx links to cComment
  -- cComment       xxx links to Comment
  -- cCommentError  xxx links to cError
  -- cOperator      xxx links to Operator
  -- cType          xxx links to Type
  -- cTypedef       xxx links to Structure
  -- cStructure     xxx links to Structure
  -- cStorageClass  xxx links to StorageClass
  -- cConstant      xxx links to Constant
  -- cPreCondit     xxx links to PreCondit
  -- cPreConditMatch xxx links to cPreCondit

  -- C++
  -- cppStatement   xxx links to Statement
  -- cppAccess      xxx links to cppStatement
  -- cppModifier    xxx links to Type
  -- cppType        xxx links to Type
  -- cppExceptions  xxx links to Exception
  -- cppOperator    xxx links to Operator
  -- cppCast        xxx links to cppStatement
  -- cppStorageClass xxx links to StorageClass
  -- cppStructure   xxx links to Structure
  -- cppBoolean     xxx links to Boolean
  -- cppConstant    xxx links to Constant
  -- cppRawStringDelimiter xxx links to Delimiter
  -- cppRawString   xxx links to String
  -- cppNumber      xxx links to Number
  -- cppFloat       xxx links to Number
  -- cppNumbers     xxx cleared
  -- cppString      xxx links to String
  -- cppCharacter   xxx links to cCharacter
  -- cppSpecialError xxx links to cSpecialError
  -- cppSpecialCharacter xxx links to cSpecialCharacter
  -- cppModule      xxx links to Include
  -- cppMinMax      xxx cleared

  -- Markdown
  -- htmlLink = {},
  -- htmlH1 = {},
  -- htmlH2 = {},
  -- htmlH3 = {},
  -- htmlH4 = {},
  -- htmlH5 = {},
  -- markdownH1 = {},
  -- markdownH2 = {},
  -- markdownH3 = {},
  -- markdownH1Delimiter = {},
  -- markdownH2Delimiter = {},
  -- markdownH3Delimiter = {},
}

-- Editor highlight groups
local editor = {
  -- NormalFloat = {},
  ColorColumn = { bg = color.GRAY1, },
  -- Conceal = {},
  -- Cursor = {},
  -- CursorIM = {},
  -- Directory = {},
  -- DiffAdd = {},
  -- DiffChange = {},
  -- DiffDelete = {},
  -- DiffText = {},
  -- EndOfBuffer = {},
  -- ErrorMsg = {},
  -- Folded = {},
  -- FoldColumn = {},
  LineNr = { fg = color.WHITE, },
  CursorLineNr = { fg = color.RED, bold = true, },
  MatchParen = { fg = color.RED, },
  -- ModeMsg = {},
  -- MoreMsg = {},
  NonText = { fg = color.BROWN_DARK, },
  Pmenu = { bg = color.GRAY1, },
  PmenuKind = { bg = color.GRAY1, },
  PmenuExtra = { bg = color.GRAY1, },
  NormalFloat = { bg = color.GRAY1, },
  PmenuSel = { bg = color.GRAY1, },
  PmenuSbar = { bg = color.GRAY1, },
  PmenuThumb = { bg = color.GRAY1, },
  -- Question = {},
  -- QuickFixLine = {},
  -- qfLineNr = {},
  IncSearch = { bg = color.BROWN_DARK, },
  Search = { bg = color.BLACK, },
  -- SpecialKey = {},
  -- SpellBad = {},
  -- SpellCap = {},
  -- SpellLocal = {},
  -- SpellRare = {},
  -- StatusLine = {},
  -- StatusLineNC = {},
  -- StatusLineTerm = {},
  -- StatusLineTermNC = {},
  -- TabLineFill = {},
  -- TablineSel = {},
  -- Tabline = {},
  -- Title = {},
  -- Visual = {},
  -- VisualNOS = {},
  -- WarningMsg = {},
  -- WildMenu = {},
  CursorColumn = { bg = color.GRAY3, },
  CursorLine = { bg = color.GRAY3, },
  -- ToolbarLine = {},
  -- ToolbarButton = {},
  -- NormalMode = {},
  -- InsertMode = {},
  -- ReplacelMode = {},
  -- VisualMode = {},
  -- CommandMode = {},
  -- Warnings = {},

  -- healthError = {},
  -- healthSuccess = {},
  -- healthWarning = {},

  -- -- dashboard
  -- DashboardShortCut = {},
  -- DashboardHeader = {},
  -- DashboardCenter = {},
  -- DashboardFooter = {},

  -- -- BufferLine
  -- BufferLineIndicatorSelected = {},
  -- BufferLineFill = {},

  -- Normal = {},
  SignColumn = { bg = color.GRAY1, },
  VertSplit = { fg = color.GRAY2, bg = color.GRAY2, },
}

-- TreeSitter highlight groups
local treesitter = {
  TSParameter = { fg = color.YELLOW, },
  TSVariable = { fg = color.YELLOW, },
  ["@constructor"] = { fg = color.PURPLE, },
  ["@constant.builtin"] = palette.PRIMITIVE,
  -- ["@error"] = { fg = color.RED, },
  ["@exception"] = palette.PRIMITIVE,
  ["@field"] = { fg = color.ORANGE, },
  ["@function"] = { fg = color.PURPLE, },
  ["@function.call"] = { fg = color.PURPLE },
  ["@function.builtin"] = palette.PRIMITIVE,
  ["@function.macro"] = syntax.Macro,
  ["@parameter"] = { fg = color.YELLOW, },
  ["@property"] = { fg = color.ORANGE, },
  ["@punctuation"] = { fg = color.TAN, },
  ["@method"] = { fg = color.PURPLE, bold = true, },
  ["@method.call"] = { fg = color.PURPLE },
  ["@string.escape"] = { fg = color.BLUE, },
  ["@punctuation.bracket"] = { fg = color.TAN, },
  ["@operator"] = { fg = color.TAN, },
  ["@repeat"] = palette.PRIMITIVE,
  ["@type.qualifier"] = palette.PRIMITIVE,
  ["@variable"] = { fg = color.WHITE, },
  ["@variable.builtin"] = palette.PRIMITIVE,

  -- TSQualifier = {},
  -- TSCharacter = {},
  -- TSConstructor = {},
  -- TSConstant = {},
  -- TSFloat = {},
  -- TSNumber = {},
  -- TSString = {},

  -- TSAttribute = {},
  -- TSBoolean = {},
  -- TSConstBuiltin = {},
  -- TSConstMacro = {},
  -- TSError = {},
  -- TSException = {},
  -- TSField = {},
  -- TSFuncMacro = {},
  -- TSInclude = {},
  -- TSLabel = {},
  -- TSNamespace = {},
  -- TSOperator = {},
  -- TSParameter = {},
  -- TSParameterReference = {},
  -- TSProperty = {},
  -- TSPunctDelimiter = {},
  -- TSPunctBracket = {},
  -- TSPunctSpecial = {},
  -- TSStringRegex = {},
  -- TSStringEscape = {},
  -- TSSymbol = {},
  -- TSType = {},
  -- TSTypeBuiltin = {},
  -- TSTag = {},
  -- TSTagDelimiter = {},
  -- TSText = {},
  -- TSTextReference = {},
  -- TSEmphasis = {},
  -- TSUnderline = {},
  -- TSTitle = {},
  -- TSLiteral = {},
  -- TSURI = {},
  -- TSAnnotation = {},
  -- TSComment = {},
  -- TSConditional = {},
  -- TSKeyword = {},
  -- TSRepeat = {},
  -- TSKeywordFunction = {},
  -- TSFunction = {},
  -- TSMethod = {},
  -- TSFuncBuiltin = {},
  -- TSVariable = {},
  -- TSVariableBuiltin = {},
}

-- Lsp highlight groups
local lsp = {
  ["@lsp.type.parameter"] = treesitter["@parameter"],
-- @lsp           xxx cleared
-- @lsp.type.class xxx links to Structure
-- @lsp.type.comment xxx links to Comment
-- @lsp.type.decorator xxx links to Function
-- @lsp.type.enum xxx links to Structure
-- @lsp.type.enumMember xxx links to Constant
-- @lsp.type.function xxx links to Function
-- @lsp.type.interface xxx links to Structure
-- @lsp.type.macro xxx links to Macro
-- @lsp.type.method xxx links to Function
-- @lsp.type.namespace xxx links to Structure
-- @lsp.type.parameter xxx links to Identifier
-- @lsp.type.property xxx links to Identifier
-- @lsp.type.struct xxx links to Structure
-- @lsp.type.type xxx links to Type
-- @lsp.type.typeParameter xxx links to Typedef
-- @lsp.type.variable xxx links to Identifier

  -- DiagnosticDefaultError = {},
  -- DiagnosticSignError = {},
  -- DiagnosticFloatingError = {},
  -- DiagnosticVirtualTextError = {},
  -- DiagnosticUnderlineError = {},
  -- DiagnosticDefaultWarn = {},
  -- DiagnosticSignWarn = {},
  -- DiagnosticFloatingWarn = {},
  -- DiagnosticVirtualTextWarn = {},
  -- DiagnosticUnderlineWarn = {},
  -- DiagnosticDefaultInfo = {},
  -- DiagnosticSignInfo = {},
  -- DiagnosticFloatingInfo = {},
  -- DiagnosticVirtualTextInfo = {},
  -- DiagnosticUnderlineInfo = {},
  -- DiagnosticDefaultHint = {},
  -- DiagnosticSignHint = {},
  -- DiagnosticFloatingHint = {},
  -- DiagnosticVirtualTextHint = {},
  -- DiagnosticUnderlineHint = {},
  -- LspReferenceText = {},
  -- LspReferenceRead = {},
  -- LspReferenceWrite = {},
}

-- Plugins highlight groups
local plugins = {
  -- -- Telescope
  -- TelescopePromptBorder = {},
  -- TelescopeResultsBorder = {},
  -- TelescopePreviewBorder = {},
  -- TelescopeSelectionCaret = {},
  -- TelescopeSelection = {},
  -- TelescopeMatching = {},

  -- -- NvimTree
  -- NvimTreeNormal = {},
  -- NvimTreeRootFolder = {},
  -- NvimTreeGitDirty = {},
  -- NvimTreeGitNew = {},
  -- NvimTreeImageFile = {},
  -- NvimTreeExecFile = {},
  -- NvimTreeSpecialFile = {},
  -- NvimTreeFolderName = {},
  -- NvimTreeEmptyFolderName = {},
  -- NvimTreeFolderIcon = {},
  -- NvimTreeIndentMarker = {},
  -- LspDiagnosticsError = {},
  -- LspDiagnosticsWarning = {},
  -- LspDiagnosticsInformation = {},
  -- LspDiagnosticsHint = {},

  -- -- Cmp
  -- CmpItemKind = {},
  -- CmpItemAbbrMatch = {},
  -- CmpItemAbbrMatchFuzzy = {},
  -- CmpItemAbbr = {},
  -- CmpItemMenu = {},

  -- -- nvim-dap
  -- DapBreakpoint = {},
  -- DapStopped = {},
}

local set_namespace = vim.api.nvim__set_hl_ns or vim.api.nvim_set_hl_ns
local namespace = vim.api.nvim_create_namespace("crystal")
local function highlight(statement)
  for name, setting in pairs(statement) do
    vim.api.nvim_set_hl(namespace, name, setting)
  end
end

local M = {}

M.setup = function()
  vim.cmd("highlight clear")
  vim.o.background = "dark"
  vim.o.termguicolors = true
  vim.g.colors_name = "crystal"
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  highlight(syntax)
  highlight(editor)
  highlight(treesitter)
  highlight(plugins)
  highlight(lsp)
  set_namespace(namespace)
end

-- Debug
vim.keymap.set("n", "<F8>", "<CMD>TSHighlightCapturesUnderCursor<CR>")
vim.keymap.set("n", "<F7>", function()
  package.loaded['jontheburger.colors.crystal'] = nil
  require('jontheburger.colors.crystal').setup() -- loads an updated version of module 'modname'
end)

return M
