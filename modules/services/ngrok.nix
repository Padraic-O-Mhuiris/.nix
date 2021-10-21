{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.services.ngrok;
  user = "ngrok";
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

    users.users."${user}" = {
      description = "Ngrok Service";
      useDefaultShell = true;
      group = user;
      isSystemUser = true;
    };

    users.groups."${user}" = { };
    user.packages = with pkgs; [ ngrok ];

    systemd.tmpfiles.rules = [ "d '${ngrokDir}' 0755 root root - -" ];

    systemd.services.ngrok = {
      description = "ngrok";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.ngrok ];

      preStart = ''
        [ -f ${cfg.configFile} ] && ${pkgs.coreutils}/bin/install -m 0400 ${cfg.configFile} ${ngrokDir}/config.yml
      '';
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.ngrok}/bin/ngrok start --all --log=stdout --config ${ngrokDir}/config.yml";
        ExecStop = "${pkgs.killall} ngrok";
        Restart = "always";

      };
    };
  };
}
