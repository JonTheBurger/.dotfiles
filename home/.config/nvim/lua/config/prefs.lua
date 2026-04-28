---@module "JVim Personalization"

---@class Colors
---@field bg string
---@field fg string
---@field red string
---@field orange string
---@field yellow string
---@field green string
---@field blue string
---@field cyan string
---@field violet string
---@field magenta string
---@field purple string
---@field white string
---@field dark_grey string
---@field brown string

---@class ConfigPreferences
---@field colors Colors
---@field ts_languages string[]
---@field uninteresting_patterns string[]
---@field ignore_patterns string[]
---@field clickable_status_line bool
---@field use_dap_view bool
---@field animate_scroll bool
---@field animate_cursor bool
---User-configurable preferences to tweak the behavior of jvim

---@type ConfigPreferences
---@diagnostic disable-next-line: missing-fields
local M = {}

---@type Colors
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

--- Languages to install with treesitter
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

--- Paths to downrank in file search
M.uninteresting_patterns = {
  "test",
  "cmake",
}

--- Paths to severely downrank in file search, exclude from folder searches
M.ignore_patterns = {
  "build",
  "external",
  "libraries",
  "mock",
  "tools",
}

--- `true` to make the status line widgets open windows on click
M.clickable_status_line = false

--- `true` to use "nvim-dap-view", `false` to use "nvim-dap-ui"
M.use_dap_view = true

--- `true` for the animate option to animate scrolling (no GUI)
M.animate_scroll = vim.fn.has("gui_running") == 0

--- `true` for the animate option to add cursor smear (no GUI and not kitty)
M.animate_cursor = (vim.fn.has("gui_running") == 0) and (vim.env.KITTY_WINDOW_ID == nil)

return M
