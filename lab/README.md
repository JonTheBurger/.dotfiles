- Secrets Manager
    - LetsEncrypt
- NextCloud
- Grafana
    - https://nixos.wiki/wiki/Grafana
    - Prometheus
- Minecraft
- GitLab
    - https://nixos.wiki/wiki/Gitlab
- SonarQube
    - https://gist.github.com/aborsu/7ca170528686c8d11dea
- Nexus
    - https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/nexus.nix

homelab nextcloud.homelab grafana.homelab nexus.homelab minecraft.homelab gitlab.homelab sonarqube.homelab

```bash
sudo mkdir -p /etc/secret
echo "super-admin-pass" | sudo tee /etc/secret/nextcloud-admin-pass
sudo chmod 600 /etc/secret/nextcloud-admin-pass
```

```nix
systemd.services."nextcloud-setup".serviceConfig = {
  LoadCredential = [ "admin-pass:/etc/secret/nextcloud-admin-pass" ];
};
systemd.services.my-app = {
  description = "My app with DB password via systemd credentials";
  wantedBy = [ "multi-user.target" ];

  serviceConfig = {
    # Dynamic user: systemd creates an ephemeral user (like uid 61111)
    DynamicUser = true;

    # Copy the secret into /run/credentials/my-app/db-pass
    LoadCredential = [ "db-pass:/etc/secret/db-pass" ];

    # Run your app, pointing it at the credential file
    ExecStart = ''
      ${pkgs.bash}/bin/bash -c '
        echo "DB password is: $(cat /run/credentials/my-app/db-pass)"
        exec sleep infinity
      ''
    '';

    # Security hardening (optional but good practice)
    NoNewPrivileges = true;
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    PrivateDevices = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
  };
};
```

```nix
# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
programs.mtr.enable = true;
programs.gnupg.agent = {
  enable = true;
  enableSSHSupport = true;
};
```
