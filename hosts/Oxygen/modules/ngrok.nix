{ config, lib, pkgs, ... }:

{
  modules.services.ngrok.enable = true;
  systemd.services.ngrok = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "ngrok ssh tunnel";
    restart = "on-failure";
    serviceConfig = {
      ExecStart =
        "${pkgs.ngrok}/bin/ngrok start --config ${config.age.secrets.ngrok-config.path}";
    };
  };
}
