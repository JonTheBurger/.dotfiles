----------------------------------------------------------------------------------------
---@section Input Configuration
----------------------------------------------------------------------------------------
local cfg = require("config")

hl.config({
  input = {
    force_no_accel = false,
    touchpad = {
      natural_scroll = true,
      scroll_factor = 0.2,
    },
  },
})
hl.device({
  name = "tpps/2-synaptics-trackpoint",
  sensitivity = -0.4,
  ---@type "flat" | "adaptive"
  accel_profile = "adaptive",
})
hl.device({
  name = "elan0678:00-04f3:3195-touchpad",
  sensitivity = 0.4,
  ---@type "flat" | "adaptive"
  accel_profile = "flat",
})

----------------------------------------------------------------------------------------
---@section Mouse + Gestures
----------------------------------------------------------------------------------------
hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "m-1" }))
hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "m+1" }))
hl.gesture({ fingers = 2, direction = "swipe", mods = "super", action = "move", scale = 3 })
hl.gesture({ fingers = 3, direction = "swipe", mods = "super", action = "resize", scale = 3 })
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace", scale = 3 })
hl.gesture({ fingers = 3, direction = "vertical", action = "special", scale = 3 })
hl.gesture({ fingers = 4, direction = "horizontal", action = "scroll_move", scale = 3 })

----------------------------------------------------------------------------------------
---@section Keys
----------------------------------------------------------------------------------------
-- Fixed Workspaces 0-9
for i = 1, cfg.workspaces do
  hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = "name:gaming" }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = "name:gaming" }))
hl.bind("SUPER + T", hl.dsp.workspace.toggle_special())
hl.bind("SUPER + SHIFT + T", hl.dsp.window.move({ workspace = "special" }))

-- HJKL
for vim, dir in pairs({ H = "left", J = "down", K = "up", L = "right" }) do
  hl.bind("SUPER + " .. vim, hl.dsp.focus({ direction = dir }))
  hl.bind("SUPER + SHIFT + " .. vim, hl.dsp.window.move({ direction = dir }))
end
hl.bind("SUPER + CONTROL + H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + SHIFT + H", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("SUPER + CONTROL + SHIFT + L", hl.dsp.focus({ workspace = "m+1" }))

-- WASD
hl.bind("SUPER + A", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("SUPER + D", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + SHIFT + A", hl.dsp.window.move({ workspace = "m-1" }))
hl.bind("SUPER + SHIFT + D", hl.dsp.window.move({ workspace = "m+1" }))

-- Monitors
hl.bind("SUPER + M", hl.dsp.window.move({ monitor = "+1" }))
for i, monitor in ipairs(cfg.monitor) do
  hl.bind("SUPER + CONTROL + " .. i, hl.dsp.focus({ monitor = monitor.output }))
end

-- Windows
hl.bind("ALT + Tab", hl.dsp.exec_cmd(cfg.app.window_switch))
hl.bind("SUPER + Escape", hl.dsp.exec_cmd(cfg.app.kill))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + Z", cfg.toggle_zoom)
hl.bind("SUPER + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + SHIFT + Semicolon", hl.dsp.layout("swapwithmaster"))
hl.bind("SUPER + SHIFT + Comma", hl.dsp.layout("swapcol l"))
hl.bind("SUPER + SHIFT + Period", hl.dsp.layout("swapcol r"))
hl.bind("SUPER + SHIFT + Slash", hl.dsp.layout("promote"))

-- Applications
hl.bind("SUPER + Return", hl.dsp.exec_cmd(cfg.app.terminal))
hl.bind("SUPER + E", hl.dsp.exec_cmd(cfg.app.file_manager))
hl.bind("SUPER + B", hl.dsp.exec_cmd(cfg.app.browser))
hl.bind("SUPER + N", hl.dsp.exec_cmd(cfg.app.editor))

-- Desktop
hl.bind("SUPER + TAB", hl.dsp.exec_cmd(cfg.app.overview))
hl.bind("SUPER + Space", hl.dsp.exec_cmd(cfg.app.launcher))
hl.bind("SUPER + V", hl.dsp.exec_cmd(cfg.app.clipboard))
hl.bind("SUPER + I", hl.dsp.exec_cmd(cfg.app.settings))
hl.bind("SUPER + Semicolon", hl.dsp.exec_cmd(cfg.app.status))
hl.bind("SUPER + Period", hl.dsp.exec_cmd(cfg.app.emoji))
hl.bind("SUPER + Apostrophe", hl.dsp.exec_cmd(cfg.app.notifications))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd(cfg.app.wallpaper))
hl.bind("SUPER + Backspace", hl.dsp.exec_cmd(cfg.app.lock))
hl.bind("CONTROL + ALT + Delete", hl.dsp.exec_cmd(cfg.app.shutdown))

-- Capture
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd(cfg.app.color_picker))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd(cfg.app.snip))
hl.bind("Print", hl.dsp.exec_cmd(cfg.app.screenshot))

-- Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(cfg.app.volume_up), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(cfg.app.volume_down), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(cfg.app.volume_mute), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(cfg.app.mic_mute), { locked = true })

-- Media
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(cfg.app.media_play), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(cfg.app.media_pause), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(cfg.app.media_next), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(cfg.app.media_prev), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(cfg.app.brightness_up), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(cfg.app.brightness_down), { locked = true, repeating = true })
