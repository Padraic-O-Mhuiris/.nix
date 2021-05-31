{ config, lib, pkgs, ... }:

{
  sops.secrets.secret_key = {};

  services.grafana = {
    enable = true;
    security.adminPasswordFile = config.sops.secrets.secret_key.path;
    addr = "0.0.0.0";
    port = 3001;
  };

  users.users.grafana.extraGroups = [ "keys" ];
  systemd.services.grafana.serviceConfig.SupplementaryGroups = [ "keys" ];

}
