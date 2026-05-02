---@module "JVim user-configurable personalizations & tweaks"

---@type jvim.Preferences
---@diagnostic disable-next-line: missing-fields
local M = {}

-- "gemini-2.5-pro"
M.ai_model = "claude-sonnet-4-6"

M.ts_languages = {
  "bash",
  "c",
  "cmake",
  "comment",
  "cpp",
  "doxygen",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "rust",
  "xml",
  "yaml",
}

M.mason_packages = {}

M.uninteresting_patterns = {
  "cmake",
  "test",
}

M.ignore_patterns = {
  "tools",
  "libraries",
  "external",
  "mock",
  "build",
}

M.clickable_status_line = false

M.use_dap_view = true

M.colors = {
  bg = "#455574",
  fg = "#bbc2cf",
  red = "#ec5f67",
  orange = "#ff8800",
  yellow = "#ecbe7b",
  green = "#78f278",
  blue = "#51afef",
  cyan = "#0084ff",
  violet = "#c489ff",
  magenta = "#ff539e",
  purple = "#9745be",
  white = "#cccccc",
  dark_grey = "#20303b",
  brown = "#885a2c",
}

return M
