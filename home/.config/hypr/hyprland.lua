hl.config({
  dwindle = {
    preserve_split = true,
  },
  misc = {
    middle_click_paste = false,
    enable_swallow = true,
    swallow_regex = "(kitty|ghostty|[Kk]onsole|Alacritty|gnome-terminal|xfce[0-9]?-terminal)",
    vrr = 3,
  },
  xwayland = {
    force_zero_scaling = true,
  },
  ecosystem = {
    no_update_news = true,
    no_donation_nag = true,
  },
})

require("config.variables")
require("config.theme")
require("config.autostart")
require("config.environment")
require("config.binds")
require("config.monitors")
require("config.windowrules")
require("config.workspaces")
