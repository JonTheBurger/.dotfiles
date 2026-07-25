-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
hl.workspace_rule({
  workspace = "name:gaming",
  monitor = PRIMARY_MONITOR,
  default = true,
  layout = "master",
  no_border = true,
  no_rounding = true,
  no_shadow = true,
  decorate = false,
})
hl.workspace_rule({ workspace = "1", monitor = MONITOR1, default = true, persistent = true, layout = "monocle" })
hl.workspace_rule({ workspace = "2", monitor = MONITOR1, default = true, persistent = true, layout = "master" })
hl.workspace_rule({ workspace = "3", monitor = MONITOR1, default = true, persistent = true, layout = "scrolling" })

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
