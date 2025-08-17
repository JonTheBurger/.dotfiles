{ pkgs, hostname, ... }:

let
  credentials = import ../credentials.nix;
in {
  environment.etc."nextcloud-admin-pass".text = credentials.nextcloud-admin-pass;
  services.nextcloud = {
    enable = true;
    datadir = "/var/homelab/nextcloud";
    package = pkgs.nextcloud31;
    hostName = "nextcloud.${hostname}";
    config.adminuser = "admin";
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    # config.adminpassFile = "/run/credentials/nextcloud.service/admin-pass";
    config.dbtype = "sqlite";
  };
}
