{
  config,
  lib,
  pkgs,
  ...
}: let
  ngrokDir = "/var/lib/ngrok";
in {
  user.packages = with pkgs; [ngrok];
  users.extraUsers.ngrok = {
    isSystemUser = true;
    shell = null;
    hashedPassword = "*";
    group = "ngrok";
  };
  users.groups."ngrok" = {};

  systemd.tmpfiles.rules = ["d '${ngrokDir}' 0700 ngrok ngrok - -"];

  systemd.services.ngrok = {
    description = "ngrok";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    path = [pkgs.ngrok];

    serviceConfig = {
      User = "ngrok";
      Group = "ngrok";
      Type = "simple";
      Restart = "always";
      RestartSec = "5";
      ExecStart = "${pkgs.ngrok}/bin/ngrok start --all --log=stdout --config ${config.age.secrets.ngrokConfig.path}";
    };
  };
}
