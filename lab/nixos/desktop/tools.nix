{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox
    starship
    wezterm
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
  environment.sessionVariables = {
    TERMINAL = "wezterm";
  };
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];
  fonts.fontDir.enable = true;
}
