hl.on("hyprland.start", function()
  hl.exec_cmd("xhost +SI:localuser:root")
  hl.exec_cmd("noctalia")

  local is_uwsm = os.getenv("UWSM_ENV")
  if not is_uwsm then
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  end
end)
