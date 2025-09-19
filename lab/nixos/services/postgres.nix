{ config, hostname, pkgs, ... }:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    dataDir = "/var/homelab/postgresql";
    port = 5432;
  };
}
