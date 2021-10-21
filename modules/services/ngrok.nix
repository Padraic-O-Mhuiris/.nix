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

    systemd.services.ngrok = {
      description = "ngrok";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.ngrok ];

      preStart = ''
        [ -d ${ngrokDir} ] || sudo ${pkgs.coreutils}/bin/install -m 0700 -d ${ngrokDir}
        ${pkgs.coreutils}/bin/install -m 0400 -o ${user} -g ${user} ${cfg.configFile} ${ngrokDir}/config.yml
      '';
      serviceConfig = {
        Type = "simple";
        User = "ngrok";
        Group = "ngrok";
        ExecStart =
          "${pkgs.ngrok}/bin/ngrok start --all --log=/var/log/ngrok --config ${ngrokDir}/config.yml";
        ExecStop = "${pkgs.killall} ngrok";
        Restart = "always";

      };
    };
  };
}
