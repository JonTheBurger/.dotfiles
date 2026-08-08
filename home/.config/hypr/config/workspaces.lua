-- Monitors
local cfg = require("config")
for _, spec in ipairs(cfg.monitor) do
  hl.monitor(spec)
end

-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
hl.workspace_rule({
  workspace = "name:gaming",
  monitor = cfg.primary_monitor.output,
  default = true,
  layout = "master",
  no_border = true,
  no_rounding = true,
  no_shadow = true,
  decorate = false,
})

hl.workspace_rule({
  workspace = "1",
  monitor = cfg.primary_monitor.output,
  default = true,
  persistent = true,
  layout = "monocle"
})

hl.workspace_rule({
  workspace = "2",
  monitor = cfg.primary_monitor.output,
  default = true,
  persistent = true,
  layout = "master"
})

hl.workspace_rule({
  workspace = "3",
  monitor = cfg.primary_monitor.output,
  default = true,
  persistent = true,
  layout = "scrolling",
  layout_opts = {
    column_width = 0.75,
    fullscreen_on_one_column = false,
    focus_fit_method = 0,
  },
})

-- Events
hl.on("hyprland.start", function()
  hl.exec_cmd("xhost +SI:localuser:root")
  hl.exec_cmd(cfg.app.shell)
  if not cfg.uwsm then
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  end
end)

hl.on("workspace.active", function(workspace)
  if not workspace then
    return
  end
  if workspace.name == "gaming" then
    hl.config({
      general = { allow_tearing = true },
      animations = { enabled = false },
    })
  else
    hl.config({
      general = { allow_tearing = false },
      animations = { enabled = true },
    })
  end
end)
