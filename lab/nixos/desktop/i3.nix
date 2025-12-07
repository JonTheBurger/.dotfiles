{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = false;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        brightnessctl
        feh
        pavucontrol
        playerctl
        polybar
        redshift
        rofi
        xorg.xinit
      ];
    };
  };
  # environment.etc."rofi/themes" = "${pkgs.rofi}/share/rofi/themes";
  services.displayManager.ly = {
    enable = true;
  };
}
