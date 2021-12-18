{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.services.ngrok;
  ngrokDir = "/var/lib/ngrok";
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
    user.packages = with pkgs; [ ngrok ];
    users.extraUsers.ngrok = {
      isSystemUser = true;
      shell = null;
      hashedPassword = "*ngrok*";
      group = "ngrok";
    };
    users.groups."ngrok" = { };

    systemd.tmpfiles.rules = [ "d '${ngrokDir}' 0700 ngrok ngrok - -" ];

    systemd.services.ngrok = {
      description = "ngrok";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.ngrok ];

      preStart = ''
        [ -f ${cfg.configFile} ] && ${pkgs.coreutils}/bin/install -m 0400 ${cfg.configFile} ${ngrokDir}/config.yml
      '';
      serviceConfig = {
        User = "ngrok";
        Group = "ngrok";
        Type = "simple";
        Restart = "always";
        RestartSec = "5";
        ExecStart =
          "${pkgs.ngrok}/bin/ngrok start --all --log=stdout --config ${ngrokDir}/config.yml";
      };
    };
  };
}
