{ config, lib, pkgs, ... }:

{
  modules.shell.ngrok.enable = true;
  systemd.services.ngrok = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "ngrok ssh tunnel";
    serviceConfig = {
      ExecStart =
        "${pkgs.ngrok}/bin/ngrok start --config ${config.age.secrets.ngrok-config.path}";
      Restart = "on-failure";
    };
  };
}
