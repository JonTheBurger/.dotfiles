local mainMod = "SUPER"
local noctCall = "noctalia msg "
-- local launchPrefix = "uwsm app -- " -- if you are not using UWSM, make this empty (e.g. "")
local launchPrefix = ""

---------------------------
---- WINDOW MANAGEMENT ----
---------------------------

-- Window manipulation
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("hyprctl kill"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
g_expanded = {}
hl.bind(mainMod .. " + Z", function()
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
hl.bind(mainMod .. " + R", hl.dsp.layout("swapwithmaster"))

-- Change focus
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd(noctCall .. "window-switcher"))

-- Move active window around workspaces & monitors
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + CONTROL + H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind("SUPER + CONTROL + L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + SHIFT + slash", hl.dsp.layout("promote"))
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = "1" }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = "2" }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = "3" }))
hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.window.move({ monitor = "+1" }))
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.window.move({ monitor = "-1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + Right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + Left", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "r-1" }))
for i = 1, NUM_WPM do
  local key = i % 10
  hl.bind(mainMod .. " + SHIFT + CONTROL + " .. key, hl.dsp.window.move({ workspace = "m~" .. i }))
end

hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = "name:gaming" }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "name:gaming" }))

-- Move & Resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

------------------
---- LAUNCHER ----
------------------

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(launchPrefix .. TERMINAL))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(launchPrefix .. EDITOR))
-- hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(launchPrefix .. CALCULATOR))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(launchPrefix .. BROWSER))
hl.bind("CONTROL + SHIFT + Escape", hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. " -e btop"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd(noctCall .. "settings-toggle"))
hl.bind(mainMod .. " + Semicolon", hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center"))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher"))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher /emo"))
-- hl.bind(mainMod .. " + L",          hl.dsp.exec_cmd(noctCall .. "session lock"))
hl.bind("CONTROL + ALT + Delete", hl.dsp.exec_cmd(noctCall .. "panel-toggle session"))

---------------------------
---- HARDWARE CONTROLS ----
---------------------------

-- Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctCall .. "volume-up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctCall .. "volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(noctCall .. "volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(noctCall .. "mic-mute"), { locked = true })

-- Media
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(noctCall .. "media toggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(noctCall .. "media toggle"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(noctCall .. "media next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(noctCall .. "media previous"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(noctCall .. "brightness-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctCall .. "brightness-down"), { locked = true, repeating = true })

-------------------
---- UTILITIES ----
-------------------

-- Screen Capture
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("Print", hl.dsp.exec_cmd(noctCall .. "screenshot-region"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(noctCall .. "screenshot-fullscreen"))

-- Theming and Wallpaper
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(noctCall .. "panel-toggle wallpaper"))

-- Clipboard
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(noctCall .. "panel-toggle clipboard"))

-- Notifications
hl.bind(mainMod .. " + apostrophe", hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center notifications"))

-------------------------------
---- WORKSPACES & MONITORS ----
-------------------------------

-- Focus on monitors
hl.bind(mainMod .. "+ TAB + 1", hl.dsp.focus({ monitor = MONITOR1 }))
hl.bind(mainMod .. "+ TAB + 2", hl.dsp.focus({ monitor = MONITOR2 }))
hl.bind(mainMod .. "+ TAB + 3", hl.dsp.focus({ monitor = MONITOR3 }))

-- Focus on workspace number
-- Absolute
for i = 1, NUM_WPM do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
end
-- Relative
for i = 1, NUM_WPM do
  local key = i % 10
  hl.bind(mainMod .. " + CONTROL + " .. key, hl.dsp.focus({ workspace = "m~" .. i }))
end

-- Move to adjacent workspaces and next empty on a given monitor
hl.bind(mainMod .. " + D", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + A", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + H", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + L", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + O", hl.dsp.focus({ workspace = "emptym" }))

-- Scroll through existing workspaces & monitors
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + mouse_up", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + mouse_down", hl.dsp.focus({ workspace = "m-1" }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + T", hl.dsp.workspace.toggle_special())

-- Input configuration
hl.config({
  input = {
    -- sensitivity = -0.25,
    accel_profile = "flat",
  },
})

hl.gesture({ fingers = 2, direction = "swipe", mods = "super", action = "move" })
hl.gesture({ fingers = 3, direction = "swipe", mods = "super", action = "resize" })
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "vertical", action = "special" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "scroll_move" })
