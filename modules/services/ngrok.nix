{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.services.ngrok;
  stateDir = "/var/lib/ngrok";
  secretsDir = "${toString ../hosts}/${config.networking.hostName}/secrets";
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
      home = stateDir;
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

      # preStart = let configYml = "${stateDir}/config.yml";
      # in ''
      #   function ngrok_setup {
      #     install --owner=ngrok --mode=600 -T ${cfg.configFile} ${configYml}
      #   }
      #   (umask 027; ngrok_setup)
      # '';

      serviceConfig = {
        Type = "simple";
        User = "ngrok";
        Group = "ngrok";
        ExecStart =
          "${pkgs.ngrok} start --all --log=stdout --config ${cfg.configFile}";
        ExecStop = "${pkgs.killall} ngrok";

      };
    };
  };
}
