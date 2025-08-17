{ config, hostname, ... }:
{
  services.grafana = {
    enable = true;
    dataDir = "/var/homelab/grafana";
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 9000;
        # Grafana needs to know on which domain and URL it's running
        domain = "grafana.${hostname}";
        # root_url = "https://your.domain/grafana/"; # Not needed if it is `https://your.domain/`
        # serve_from_sub_path = true;
      };
    };
  };
  services.nginx.virtualHosts."grafana.${hostname}" = {
    # addSSL = true;
    # enableACME = true;
    # locations."/grafana/" = {
    locations."/" = {
        proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
    };
  };
}
