-- Look and feel configuration
local cfg = require("config")

hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 3,
    border_size = 2,
    extend_border_grab_area = 10,
    resize_on_border = true,
    col = {
      active_border = {
        colors = { cfg.colors.red, cfg.colors.red2 },
        angle = 45,
      },
      inactive_border = cfg.colors.gray,
    },
  },
  group = {
    col = {
      border_active = cfg.colors.lblue,
      border_inactive = cfg.colors.gray,
      border_locked_active = cfg.colors.dblue,
      border_locked_inactive = cfg.colors.gray,
    },
    groupbar = {
      col = {
        active = cfg.colors.lgreen,
        inactive = cfg.colors.gray,
        locked_active = cfg.colors.dblue,
        locked_inactive = cfg.colors.gray,
      },
    },
  },
  decoration = {
    dim_special = 0.3,
    rounding = cfg.theme.rounding,
    active_opacity = 0.95,
    inactive_opacity = 0.85,
    fullscreen_opacity = 1,
    blur = {
      size = 5,
      passes = 4,
      special = true,
    },
  },
  dwindle = {
    preserve_split = true,
  },
  xwayland = {
    force_zero_scaling = true,
  },
  ecosystem = {
    no_update_news = true,
    no_donation_nag = true,
  },
  misc = {
    col = {
      splash = cfg.colors.lgreen,
    },
    middle_click_paste = false,
    enable_swallow = true,
    swallow_regex = "(kitty|ghostty|[Kk]onsole|Alacritty|gnome-terminal|xfce[0-9]?-terminal)",
    vrr = 3,
  },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("overshoot", { type = "bezier", points = { { 0.5, 0.9 }, { 0.1, 1.1 } } })

hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
hl.curve("rubber", { type = "spring", mass = 1, stiffness = 70, dampening = 10 })

hl.animation({ leaf = "global", enabled = true, speed = 3, bezier = "quick" })
hl.animation({ leaf = "windows", enabled = true, speed = 3, spring = "easy", style = "slide" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "quick", style = "slide" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 2, bezier = "quick", style = "slide top" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 2, bezier = "quick", style = "slide bottom" })
