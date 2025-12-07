local wezterm = require("wezterm")
local act = wezterm.action
local HJKL2DIRECTION = { h = "Left", j = "Down", k = "Up", l = "Right" }
local PREVIOUS_WORKSPACE = "default"
local ROSEWATER = "#f5e0dc"
local FLAMINGO = "#f2cdcd"
local PINK = "#f5c2e7"
local MAUVE = "#cba6f7"
local RED = "#f38ba8"
local MAROON = "#eba0ac"
local PEACH = "#fab387"
local YELLOW = "#f9e2af"
local GREEN = "#a6e3a1"
local TEAL = "#94e2d5"
local SKY = "#89dceb"
local SAPPHIRE = "#74c7ec"
local BLUE = "#89b4fa"
local LAVENDER = "#b4befe"
local TEXT = "#cdd6f4"
local SUBTEXT_1 = "#bac2de"
local SUBTEXT_0 = "#a6adc8"
local OVERLAY_2 = "#9399b2"
local OVERLAY_1 = "#7f849c"
local OVERLAY_0 = "#6c7086"
local SURFACE_2 = "#585b70"
local SURFACE_1 = "#45475a"
local SURFACE_0 = "#313244"
local BASE = "#1e1e2e"
local MANTLE = "#181825"
local CRUST = "#11111b"
local TITLEBAR_COLOR = SURFACE_0

--- @type Config
local config = wezterm.config_builder()

--------------------------------------------------------------------------------
-- @SECTION functions
--------------------------------------------------------------------------------
--- Smart splits integration
---@param resize_or_move "move"|"resize" action to delegate to smart-splits.nvim
---@param key string Key to forward to neovim
---@return Key WezTerm Key mapping
local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == "resize" and "META" or "CTRL",
    action = wezterm.action_callback(function(win, pane)
      if pane:get_user_vars().IS_NVIM == "true" then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
        }, pane)
      else
        if resize_or_move == "resize" then
          win:perform_action({ AdjustPaneSize = { HJKL2DIRECTION[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = HJKL2DIRECTION[key] }, pane)
        end
      end
    end),
  }
end

---@param direction "Left"|"Right"|"Up"|"Down"
---@param amount integer Cells to resize
local function resize_pane(direction, amount)
  return act.Multiple({
    act.AdjustPaneSize({ direction, amount }),
    act.ActivateKeyTable({
      name = "resize_pane",
      replace_current = true,
      until_unknown = true,
      timeout_milliseconds = 750,
    }),
  })
end

local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

--- Recomputes text for tab title - synchronous in GUI thread
---@param tab TabInformation The active tab
---@param tabs TabInformation[] All tabs in the window
---@param panes PaneInformation[] All panes in the active tab
---@param cfg Config Effective configuration of the window
---@param hover boolean True if the current tab is hovered
---@param max_width integer Max number of cells available to draw this tab (in retro style)
---@return string|table[string, FormatItem] Title of tab
local function format_tab(tab, tabs, panes, cfg, hover, max_width)
  local title = tab_title(tab)
  if tab.is_active then
    return {
      { Foreground = { Color = TITLEBAR_COLOR } },
      { Background = { Color = PEACH } },
      { Text = " " .. tostring(tab.tab_index) .. " " },
      { Foreground = { Color = TEXT } },
      { Background = { Color = BASE } },
      { Text = " " .. title .. " " },
    }
  else
    return {
      { Foreground = { Color = TITLEBAR_COLOR } },
      { Background = { Color = BLUE } },
      { Text = " " .. tostring(tab.tab_index) .. " " },
      { Foreground = { Color = SUBTEXT_0 } },
      { Background = { Color = TITLEBAR_COLOR } },
      { Text = " " .. title .. " " },
    }
  end
end

---@param win Window
---@param pane Pane
local function toggle_term(win, pane)
  local current = win:active_workspace()
  if current == "toggle" then
    win:perform_action(act.SwitchToWorkspace({ name = PREVIOUS_WORKSPACE }), pane)
  else
    PREVIOUS_WORKSPACE = current
    win:perform_action(act.SwitchToWorkspace({ name = "toggle" }), pane)
  end
end

local RenameTab = act.PromptInputLine({
  description = "Enter new name for tab",
  action = wezterm.action_callback(function(window, pane, line)
    if line then
      window:active_tab():set_title(line)
    end
  end),
})

--------------------------------------------------------------------------------
-- @SECTION keys
--------------------------------------------------------------------------------
--- https://wezterm.org/config/lua/keyassignment/index.html#available-key-assignments
-- config.disable_default_key_bindings = true
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  -- Forward leader
  { key = "q", mods = "LEADER|CTRL", action = act.SendKey({ key = "q", mods = "CTRL" }) },
  -- Pane / Split Lifetime
  { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "/", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  -- { key = "Space", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  -- Navigation
  split_nav("move", "h"),
  split_nav("move", "j"),
  split_nav("move", "k"),
  split_nav("move", "l"),
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "1", mods = "ALT", action = act.ActivateTab(0) },
  { key = "2", mods = "ALT", action = act.ActivateTab(1) },
  { key = "3", mods = "ALT", action = act.ActivateTab(2) },
  { key = "4", mods = "ALT", action = act.ActivateTab(3) },
  { key = "5", mods = "ALT", action = act.ActivateTab(4) },
  { key = "6", mods = "ALT", action = act.ActivateTab(5) },
  { key = "7", mods = "ALT", action = act.ActivateTab(6) },
  { key = "8", mods = "ALT", action = act.ActivateTab(7) },
  { key = "9", mods = "ALT", action = act.ActivateTab(-1) },
  { key = "j", mods = "ALT", action = act.ActivateTabRelative(-1) },
  { key = "k", mods = "ALT", action = act.ActivateTabRelative(1) },
  -- Moving
  { key = "j", mods = "ALT|SHIFT", action = act.MoveTabRelative(-1) },
  { key = "k", mods = "ALT|SHIFT", action = act.MoveTabRelative(1) },
  { key = "}", mods = "LEADER|SHIFT", action = act.RotatePanes("Clockwise") },
  { key = "{", mods = "LEADER|SHIFT", action = act.RotatePanes("CounterClockwise") },
  -- Resizing
  { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "+", mods = "CTRL", action = act.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
  { key = "0", mods = "CTRL", action = act.ResetFontSize },
  { key = ">", mods = "LEADER|SHIFT", action = resize_pane("Right", 4) },
  { key = "<", mods = "LEADER|SHIFT", action = resize_pane("Left", 4) },
  { key = "v", mods = "LEADER", action = resize_pane("Down", 4) },
  { key = "^", mods = "LEADER|SHIFT", action = resize_pane("Up", 4) },
  -- Clipboard
  { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
  { key = "f", mods = "LEADER", action = act.QuickSelectArgs({ patterns = { [[\S+]] } }) },
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
  -- { key = "F", mods = "CTRL|SHIFT", action = act.Search() },
  -- Misc
  -- https://wezterm.org/config/launch.html#the-launcher-menu
  { key = "T", mods = "CTRL|SHIFT", action = act.ShowLauncher },
  { key = "P", mods = "CTRL|SHIFT", action = act.ActivateCommandPalette },
  { key = "L", mods = "CTRL|SHIFT", action = act.ShowDebugOverlay },
  { key = "U", mods = "CTRL|SHIFT", action = act.CharSelect },
  { key = "k", mods = "CTRL|SHIFT", action = act.ResetTerminal },
  { key = "R", mods = "CTRL|SHIFT", action = act.ReloadConfiguration },
  { key = "R", mods = "LEADER|SHIFT", action = RenameTab },
  { key = "t", mods = "ALT", action = wezterm.action_callback(toggle_term) },
}

if wezterm.gui then
  local copy_mode = wezterm.gui.default_key_tables().copy_mode
  table.insert(copy_mode, { key = "B", mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") })
  table.insert(copy_mode, { key = "W", mods = "SHIFT", action = act.CopyMode("MoveForwardWord") })
  table.insert(copy_mode, { key = "E", mods = "SHIFT", action = act.CopyMode("MoveForwardWordEnd") })
  table.insert(copy_mode, { key = "/", action = act.Search({ CaseInSensitiveString = "" }) })
  table.insert(copy_mode, { key = "n", action = act.CopyMode("NextMatch") })
  table.insert(copy_mode, { key = "p", action = act.CopyMode("PriorMatch") })
  -- act.CopyMode("ClearSelectionMode")
  config.key_tables = {
    copy_mode = copy_mode,
    search_mode = {
      { key = "Escape", action = act.CopyMode("Close") },
      { key = "c", mods = "CTRL", action = act.CopyMode("Close") },
      { key = "Enter", action = act.ActivateCopyMode },
    },
    resize_pane = {
      { key = ">", mods = "SHIFT", action = resize_pane("Right", 4) },
      { key = "<", mods = "SHIFT", action = resize_pane("Left", 4) },
      { key = "v", action = resize_pane("Down", 4) },
      { key = "^", mods = "SHIFT", action = resize_pane("Up", 4) },
      { key = "h", action = resize_pane("Left", 1) },
      { key = "l", action = resize_pane("Right", 1) },
      { key = "k", action = resize_pane("Up", 1) },
      { key = "j", action = resize_pane("Down", 1) },
      { key = "Escape", action = "PopKeyTable" },
    },
  }
end
-- require("side_pane").apply_to_config(config)

--------------------------------------------------------------------------------
-- @SECTION theme
--------------------------------------------------------------------------------
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.85
-- https://wezterm.org/colorschemes/c/index.html#catppuccin-mocha_1
config.color_scheme = "CGA"
-- https://wezterm.org/config/fonts.html
config.font = wezterm.font_with_fallback({
  "FiraMono Nerd Font",
  "Fira Code",
  "JetBrains Mono",
})
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
if wezterm.target_triple:find("linux") ~= nil then
  config.window_decorations = "NONE"
  config.default_prog = { "zsh" }
end

wezterm.on("format-tab-title", format_tab)
wezterm.on("update-status", function(window, pane)
  local cells = {}
  local hostname = wezterm.hostname()
  table.insert(cells, " " .. hostname)
  local date = wezterm.strftime(" %a %b %-d %H:%M")
  table.insert(cells, date)
  local d = wezterm.procinfo.current_working_dir_for_pid(wezterm.procinfo.pid())
  table.insert(cells, d)

  local text_fg = TITLEBAR_COLOR
  local colors = {
    TITLEBAR_COLOR,
    MAUVE,
    YELLOW,
    GREEN,
    RED,
  }

  local elements = {}
  while #cells > 0 and #colors > 1 do
    local text = table.remove(cells, 1)
    local prev_color = table.remove(colors, 1)
    local curr_color = colors[1]

    table.insert(elements, { Background = { Color = prev_color } })
    table.insert(elements, { Foreground = { Color = curr_color } })
    table.insert(elements, { Text = "" })
    table.insert(elements, { Background = { Color = curr_color } })
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Text = " " .. text .. " " })
  end
  window:set_right_status(wezterm.format(elements))
end)

wezterm.on("augment-command-palette", function(w, p)
  return {
    {
      brief = "Take screenshot",
      icon = "cod_device_camera",

      action = act.PromptInputLine({
        description = "Screenshot name",
        -- initial_value = os.date('%Y%m%dT%H%M%S--terminal-screenshot'), -- apparently this requires a nightly build
        action = wezterm.action_callback(function(window, pane, line)
          local function append_tables(...)
            local result = {}
            for _, tbl in ipairs({ ... }) do
              for i = 1, #tbl do
                result[#result + 1] = tbl[i]
              end
            end
            return result
          end
          if line then
            local dimensions = pane:get_dimensions()
            -- local theme = wezterm.get_builtin_color_schemes()[window:effective_config().color_scheme]
            local theme = wezterm.get_builtin_schemes()[window:effective_config().color_scheme]
            local body = { 0, "o", pane:get_lines_as_escapes() }

            local header = {
              version = 3,
              term = {
                cols = dimensions.cols,
                rows = dimensions.viewport_rows,
                theme = {
                  fg = theme.foreground,
                  bg = theme.background,
                  palette = table.concat(append_tables(theme.ansi, theme.brights), ":"),
                },
              },
            }

            local f = require("io").open(line .. ".cast", "w+")
            f:write(wezterm.json_encode(header) .. "\n")
            f:write(wezterm.json_encode(body))
            f:flush()
            f:close()
          end
        end),
      }),
    },
  }
end)

return config
