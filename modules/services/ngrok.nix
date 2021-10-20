{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.services.ngrok;
  stateDir = "/var/lib/ngrok";
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

    users.users = {
      ngrok = {
        description = "Ngrok Service";
        home = stateDir;
        useDefaultShell = true;
        group = "ngrok";
        isSystemUser = true;
      };
    };

    users.groups.ngrok = { };

    user.packages = with pkgs; [ ngrok ];

    systemd.services.ngrok = {
      description = "ngrok";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.ngrok ];

      preStart = let configYml = "${stateDir}/config.yml";
      in ''
        function ngrok_setup {
          cat ${cfg.configFile} > ${config.yml}
        }
        (umask 027; ngrok_setup)
      '';

      serviceConfig = {
        Type = "simple";
        User = "ngrok";
        Group = "ngrok";
        WorkingDirectory = stateDir;
        ExecStart =
          "${pkgs.ngrok} start --all --log=stdout --config ${stateDir}/config.yml";
        ExecStop = "${pkgs.killall} ngrok";

      };
    };
  };
}
