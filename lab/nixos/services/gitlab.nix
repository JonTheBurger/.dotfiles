{ hostname, ... }:
{
  # https://nixos.wiki/wiki/Gitlab
  services.gitlab = {
    enable = true;
    databasePasswordFile = "";
    initialRootPasswordFile = "";
    secrets = {
      secretFile = "";
      optFile = "";
      dbFile = "";
      jwsFile = "";
    };
  };
  services.nginx.virtualHosts."gitlab.${hostname}" = {
    locations."/" = {
      proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
    };
  };
  systemd.services.gitlab-backup.environment = {
    BACKUP = "dump";
  };
}
