---@class jvim.Colors
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

---@class jvim.Preferences
---@field ai_model string From https://models.dev/
---@field ts_languages string[] Languages to install with treesitter
---@field mason_packages string[] Mason LSPs, Formatters, and Linters to auto-install (see :Mason)
---@field uninteresting_patterns string[] Paths to downrank in file search (later in list == more down-ranked)
---@field ignore_patterns string[] Paths to severely downrank in file search, exclude from folder searches (later in list == more down-ranked)
---@field clickable_status_line bool `true` to make the status line widgets open windows on click
---@field use_dap_view bool `true` to use "nvim-dap-view", `false` to use "nvim-dap-ui"
---@field colors jvim.Colors Color codes to apply to custom highlights, such as diagnostics

---@class jvim.Breakpoint
---@field line integer Line number
---@field condition? string An optional condition to trigger the breakpoint
---@field hit_condition? string Number of hits a breakpoint must hit before activating
---@field log_message? string Message to log when hit

---@class jvim.SourceLocation
---@field file string Path to file on disk
---@field line integer? Line number
---@field col integer? Column number

---@class jvim.FindExecutableOpts
---@field timeout integer? Milliseconds to search, 10'000 (10 seconds) by default
---@field max_depth integer? Number of directories to search. 20 by default.

---@class jvim.EditFileOpts
---@field chdir boolean? Also change to the directory
---@field initial_contents string? Initial contents of file, if it did not exist
