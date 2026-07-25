-- Environmental variables (for reference https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/)
-- if you use UWSM, define your variables in ~/.config/uwsm/env
-- if you don't use UWSM, define your variables here (e.g. hl.env("QT_QPA_PLATFORM", "wayland"))
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
-- hl.env("WLR_DRM_NO_ATOMIC", "1")

-- if you have an NVIDIA GPU uncomment the following lines:
-- hl.env("GBM_BACKEND", "nvidia-drm") -- force GBM as a backend
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia") -- force GBM as a backend
-- hl.env("LIBVA_DRIVER_NAME", "nvidia") -- Hardware acceleration on NVIDIA GPUs
-- hl.env("__GL_GSYNC_ALLOWED", "1") -- Controls if G-Sync capable monitors should use Variable Refresh Rate (VRR)

-- Hyprland default apps
TERMINAL = "kitty"
FILE_MANAGER = "dolphin"
BROWSER = "brave"
EDITOR = "neovide"
CALCULATOR = ""

-- Monitors
MONITOR1 = ""
MONITOR2 = ""
MONITOR3 = ""
PRIMARY_MONITOR = MONITOR1

-- Workspaces
NUM_WPM = 3 -- Number of workspaces per monitor (Max 10)

-- Cachy colors
CACHYLGREEN = "rgba(82dcccff)"
CACHYMGREEN = "rgba(00aa84ff)"
CACHYDGREEN = "rgba(007d6fff)"
CACHYLBLUE = "rgba(01ccffff)"
CACHYMBLUE = "rgba(182545ff)"
CACHYDBLUE = "rgba(111826ff)"
CACHYWHITE = "rgba(ffffffff)"
CACHYGREY = "rgba(ddddddff)"
CACHYGRAY = "rgba(798bb2ff)"

-- Theme
ROUNDING = 8
