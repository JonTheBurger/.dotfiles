local noctalia = "noctalia msg "

-- hl.notification.create({
--   text = "JON " .. tostring(is_uwsm),
--   timeout = 5000, -- Duration in milliseconds
--   icon = "ok"     -- Pre-defined icon string or index
-- })

---------------------------
---- WINDOW MANAGEMENT ----
---------------------------

-- hl.dispatch()

-- Window manipulation
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("hyprctl kill"))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))

hl.bind("SUPER + F", hl.dsp.window.fullscreen())
g_expanded = {}
hl.bind("SUPER + Z", function()
  local win = hl.get_active_window()
  if not win then
    return
  end

  local workspace = hl.get_active_workspace()
  if not workspace then
    return
  end

  if workspace.tiled_layout == "scrolling" then
    if g_expanded[win.address] then
      hl.dispatch(hl.dsp.layout("colresize 0.5"))
      g_expanded[win.address] = false
    else
      hl.dispatch(hl.dsp.layout("colresize 1.0"))
      g_expanded[win.address] = true
    end
  else
    hl.dispatch(hl.dsp.window.fullscreen({ mode = 1 }))
  end
end)
hl.bind("SUPER + R", hl.dsp.layout("swapwithmaster"))

-- Change focus
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
hl.bind("SUPER + Tab", hl.dsp.exec_cmd(noctalia .. "window-switcher"))

-- Move active window around workspaces & monitors
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + CONTROL + H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + comma", hl.dsp.layout("swapcol l"))
hl.bind("SUPER + SHIFT + period", hl.dsp.layout("swapcol r"))
hl.bind("SUPER + SHIFT + slash", hl.dsp.layout("promote"))
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = "1" }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = "2" }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = "3" }))
hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.window.move({ monitor = "+1" }))
hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.window.move({ monitor = "-1" }))
hl.bind("SUPER + CONTROL + SHIFT + Right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind("SUPER + CONTROL + SHIFT + Left", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind("SUPER + CONTROL + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind("SUPER + CONTROL + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "r-1" }))
for i = 1, NUM_WPM do
  local key = i % 10
  hl.bind("SUPER + SHIFT + CONTROL + " .. key, hl.dsp.window.move({ workspace = "m~" .. i }))
end

hl.bind("SUPER + 0", hl.dsp.focus({ workspace = "name:gaming" }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = "name:gaming" }))

-- Move & Resize with mouse
hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())

------------------
---- LAUNCHER ----
------------------

hl.bind("SUPER + Return", hl.dsp.exec_cmd(launch .. TERMINAL))
hl.bind("SUPER + E", hl.dsp.exec_cmd(launch .. FILE_MANAGER))
hl.bind("SUPER + N", hl.dsp.exec_cmd(launch .. EDITOR))
-- hl.bind("SUPER + C", hl.dsp.exec_cmd(launchPrefix .. CALCULATOR))
hl.bind("SUPER + B", hl.dsp.exec_cmd(launch .. BROWSER))
hl.bind("CONTROL + SHIFT + Escape", hl.dsp.exec_cmd(launch .. TERMINAL .. " -e btop"))
hl.bind("SUPER + I", hl.dsp.exec_cmd(noctalia .. "settings-toggle"))
hl.bind("SUPER + Semicolon", hl.dsp.exec_cmd(noctalia .. "panel-toggle control-center"))
hl.bind("SUPER + Space", hl.dsp.exec_cmd(noctalia .. "panel-toggle launcher"))
hl.bind("SUPER + period", hl.dsp.exec_cmd(noctalia .. "panel-toggle launcher /emo"))
-- hl.bind("SUPER + L",          hl.dsp.exec_cmd(noctCall .. "session lock"))
hl.bind("CONTROL + ALT + Delete", hl.dsp.exec_cmd(noctalia .. "panel-toggle session"))

---------------------------
---- HARDWARE CONTROLS ----
---------------------------

-- Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctalia .. "volume-up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctalia .. "volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(noctalia .. "volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(noctalia .. "mic-mute"), { locked = true })

-- Media
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(noctalia .. "media toggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(noctalia .. "media toggle"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(noctalia .. "media next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(noctalia .. "media previous"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(noctalia .. "brightness-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctalia .. "brightness-down"), { locked = true, repeating = true })

-------------------
---- UTILITIES ----
-------------------

-- Screen Capture
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("Print", hl.dsp.exec_cmd(noctalia .. "screenshot-region"))
hl.bind("SUPER + Print", hl.dsp.exec_cmd(noctalia .. "screenshot-fullscreen"))

-- Theming and Wallpaper
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd(noctalia .. "panel-toggle wallpaper"))

-- Clipboard
hl.bind("SUPER + V", hl.dsp.exec_cmd(noctalia .. "panel-toggle clipboard"))

-- Notifications
hl.bind("SUPER + apostrophe", hl.dsp.exec_cmd(noctalia .. "panel-toggle control-center notifications"))

-------------------------------
---- WORKSPACES & MONITORS ----
-------------------------------

-- Focus on monitors
hl.bind("SUPER+ TAB + 1", hl.dsp.focus({ monitor = MONITOR1 }))
hl.bind("SUPER+ TAB + 2", hl.dsp.focus({ monitor = MONITOR2 }))
hl.bind("SUPER+ TAB + 3", hl.dsp.focus({ monitor = MONITOR3 }))

-- Focus on workspace number
-- Absolute
for i = 1, NUM_WPM do
  local key = i % 10
  hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
end
-- Relative
for i = 1, NUM_WPM do
  local key = i % 10
  hl.bind("SUPER + CONTROL + " .. key, hl.dsp.focus({ workspace = "m~" .. i }))
end

-- Move to adjacent workspaces and next empty on a given monitor
hl.bind("SUPER + D", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + A", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("SUPER + CONTROL + SHIFT + H", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("SUPER + CONTROL + SHIFT + L", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + O", hl.dsp.focus({ workspace = "emptym" }))

-- Scroll through existing workspaces & monitors
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("SUPER + CONTROL + mouse_up", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + CONTROL + mouse_down", hl.dsp.focus({ workspace = "m-1" }))

-- Special workspace (scratchpad)
hl.bind("SUPER + SHIFT + T", hl.dsp.window.move({ workspace = "special" }))
hl.bind("SUPER + T", hl.dsp.workspace.toggle_special())

-- Input configuration
hl.config({
  input = {
    force_no_accel = false,
    touchpad = {
      natural_scroll = true,
      scroll_factor = 0.2,
    }
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

hl.gesture({ fingers = 2, direction = "swipe", mods = "super", action = "move", scale = 3 })
hl.gesture({ fingers = 3, direction = "swipe", mods = "super", action = "resize", scale = 3 })
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace", scale = 3 })
hl.gesture({ fingers = 3, direction = "vertical", action = "special", scale = 3 })
hl.gesture({ fingers = 4, direction = "horizontal", action = "scroll_move", scale = 3 })
