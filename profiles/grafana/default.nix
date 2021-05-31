{ config, lib, pkgs, ... }:

{
  sops.secrets.secret = {};

  services.grafana = {
    enable = true;
    security.adminPasswordFile = config.sops.secrets.secret.path;
    addr = "0.0.0.0";
    port = 3001;
  };

  users.users.grafana.extraGroups = [ "keys" ];
  systemd.services.grafana.serviceConfig.SupplementaryGroups = [ "keys" ];

}
