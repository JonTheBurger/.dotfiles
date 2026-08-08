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
local noctalia = "noctalia msg "

M.prefix = ""
if M.uwsm then
  M.prefix = "uwsm app -- "
end

M.app = {
  terminal = "kitty",
  file_manager = "dolphin",
  browser = "brave",
  editor = "neovide",
  shell = "noctalia",

  launcher = noctalia .. "panel-toggle launcher",
  settings = noctalia .. "settings-toggle",
  window_switch = noctalia .. "window-switcher",
  color_picker = "hyprpicker -a",
  snip = noctalia .. "screenshot-region",
  screenshot = noctalia .. "screenshot-fullscreen",
  clipboard = noctalia .. "panel-toggle clipboard",
  notifications = noctalia .. "panel-toggle control-center notifications",
  wallpaper = noctalia .. "panel-toggle wallpaper",
  lock = noctalia .. "session lock",
  emoji = noctalia .. "panel-toggle launcher /emo",
  shutdown = noctalia .. "panel-toggle session",
  status = noctalia .. "panel-toggle control-center",

  volume_up = noctalia .. "volume-up",
  volume_down = noctalia .. "volume-down",
  volume_mute = noctalia .. "volume-mute",
  mic_mute = noctalia .. "mic-mute",
  media_play = noctalia .. "media toggle",
  media_pause = noctalia .. "media toggle",
  media_next = noctalia .. "media next",
  media_prev = noctalia .. "media previous",
  brightness_up = noctalia .. "brightness-up",
  brightness_down = noctalia .. "brightness-down",
}
for i, cmd in ipairs(M.app) do
  M.app[i] = M.prefix .. cmd
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
