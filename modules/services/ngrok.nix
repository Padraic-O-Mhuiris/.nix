{ config, lib, pkgs, ... }:

with lib;

let cfg = config.modules.services.ngrok;
in {
  options.modules.services.ngrok = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable ngrok service";
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to config.yml";
    };
  };

  config = mkIf cfg.enable {

    users.users.ngrok = {
      description = "Ngrok Service";
      useDefaultShell = true;
      group = "ngrok";
      isSystemUser = true;
    };

    users.groups.ngrok = { };

    user.packages = with pkgs; [ ngrok ];

    systemd.services.ngrok = {
      description = "ngrok";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.ngrok ];
      serviceConfig = {
        Type = "simple";
        User = "ngrok";
        Group = "ngrok";
        ExecStart =
          "${pkgs.ngrok}/bin/ngrok start --all --log=stdout --config ${cfg.configFile}";
        ExecStop = "${pkgs.killall} ngrok";

      };
    };
  };
}
