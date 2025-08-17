# sudo nixos-rebuild switch
# https://nixos.org/manual/nixpkgs/stable
{ config, pkgs, ... }:

let
  hostname = "homelab";
in {
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  nixpkgs.config.allowUnfree = true;
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./services/nginx.nix
      ./services/minecraft.nix
      ./services/nextcloud.nix
      (import ./services/nextcloud.nix { inherit pkgs hostname; })
      # ./services/sonarqube.nix
      (import ./services/grafana.nix { inherit config hostname; })
      # (import ./services/gitlab.nix { inherit hostname; })
    ];

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Packages (nix search btop)
  environment.systemPackages = with pkgs; [
    btop
    (vim_configurable.customize {
      name = "vim";
      vimrcConfig.customRC = (builtins.readFile ./config/vimrc);
    })
  ];

  # Services
  services.logind.lidSwitch = "ignore";
  services.openssh.enable = true;

  # Users
  users.users.jon = {
    isNormalUser = true;
    description = "Jon";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
}
