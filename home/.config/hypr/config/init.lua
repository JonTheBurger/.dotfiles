local M = {}

M.notify = function(message)
  hl.notification.create({
    text = tostring(message),
    timeout = 5000, -- milliseconds
    icon = "ok",
  })
end

--- `true` when uwsm is running
M.uwsm = not not os.getenv("UWSM_FINALIZE_VARNAMES")
local ipc = "noctalia msg "

M.prefix = ""
if M.uwsm then
  M.prefix = "uwsm app -- "
  M.notify("uwsm detected")
end

M.services = {
  "noctalia",
  "qs -c overview",
}
M.app = {
  terminal = "kitty",
  file_manager = "dolphin",
  browser = "brave",
  editor = "neovide",

  overview = "qs ipc -c overview call overview toggle",
  launcher = ipc .. "panel-toggle launcher",
  clipboard = ipc .. "panel-toggle clipboard",
  settings = ipc .. "settings-toggle",
  status = ipc .. "panel-toggle control-center",
  emoji = ipc .. "panel-toggle launcher /emo",
  notifications = ipc .. "panel-toggle control-center notifications",
  wallpaper = ipc .. "panel-toggle wallpaper",
  lock = ipc .. "session lock",
  shutdown = ipc .. "panel-toggle session",

  window_switch = ipc .. "window-switcher",
  kill = "hyprctl kill",
  color_picker = "hyprpicker -a",
  snip = ipc .. "screenshot-region",
  screenshot = ipc .. "screenshot-fullscreen",

  volume_up = ipc .. "volume-up",
  volume_down = ipc .. "volume-down",
  volume_mute = ipc .. "volume-mute",
  mic_mute = ipc .. "mic-mute",
  media_play = ipc .. "media toggle",
  media_pause = ipc .. "media toggle",
  media_next = ipc .. "media next",
  media_prev = ipc .. "media previous",
  brightness_up = ipc .. "brightness-up",
  brightness_down = ipc .. "brightness-down",
}
for i, cmd in ipairs(M.services) do
  M.services[i] = M.prefix .. cmd
end
for name, cmd in pairs(M.app) do
  M.app[name] = M.prefix .. cmd
end

--- See `hyprctl monitors`, https://wiki.hypr.land/Configuring/Basics/Monitors/
---@type HL.MonitorSpec[]
M.monitor = {
  {
    output = "",
    mode = "preferred", -- "1920x1080@60"
    position = "auto", -- "0x0"
    scale = "1",
  },
}
M.primary_monitor = M.monitor[1]
M.workspaces = 3

M.colors = {
  red = "rgba(dd00ffcc)",
  red2 = "rgba(dd00ddcc)",
  lgreen = "rgba(82dcccff)",
  mgreen = "rgba(00aa84ff)",
  dgreen = "rgba(007d6fff)",
  lblue = "rgba(01ccffff)",
  mblue = "rgba(182545ff)",
  dblue = "rgba(111826ff)",
  white = "rgba(ffffffff)",
  grey = "rgba(ddddddff)",
  gray = "rgba(798bb2ff)",
}

M.theme = {
  rounding = 8,
}

local expanded_windows = {}
M.toggle_zoom = function()
  local win = hl.get_active_window()
  if not win then
    return
  end

  local workspace = hl.get_active_workspace()
  if not workspace then
    return
  end

  if workspace.tiled_layout == "scrolling" then
    if expanded_windows[win.address] then
      hl.dispatch(hl.dsp.layout("colresize 0.5"))
      expanded_windows[win.address] = false
    else
      hl.dispatch(hl.dsp.layout("colresize 1.0"))
      expanded_windows[win.address] = true
    end
  else
    hl.dispatch(hl.dsp.window.fullscreen({ mode = 1 }))
  end
end

return M
