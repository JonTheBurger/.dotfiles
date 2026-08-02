---@module "JVim user-configurable personalizations & tweaks"

---@type jvim.Preferences
---@diagnostic disable-next-line: missing-fields
local M = {}

-- "claude-opus-4.6"
-- "claude-opus-4.7"
-- "claude-sonnet-4.6"
-- "gemini-3.1-pro-preview"
-- "gpt-5.2-codex"
-- "gpt-5.3-codex"
-- "gpt-5.4-mini"
-- "gpt-5.4"
-- "gpt-5.5"
-- "gpt-5-mini"
-- "gpt-4o-mini-2024-07-18"
-- "gpt-4o-2024-11-20"
-- "gpt-4o-2024-08-06"
-- "claude-sonnet-4.5"
-- "claude-opus-4.5"
-- "claude-haiku-4.5"
-- "gemini-3-flash-preview"
-- "gemini-2.5-pro"
-- "gpt-4.1-2025-04-14"
-- "gpt-5.2"
-- "gpt-3.5-turbo-0613"
-- "gpt-4"
-- "gpt-4-0613"
-- "gpt-4o-2024-05-13"
-- "gpt-4-o-preview"
-- "gpt-4.1"
-- "gpt-3.5-turbo"
-- "gpt-4o-mini"
-- "gpt-4o"
M.ai_model = "" -- "claude-sonnet-4.6"

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
  "Build",
  ".venv",
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
