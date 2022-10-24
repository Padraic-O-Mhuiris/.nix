{
  config,
  lib,
  pkgs,
  ...
}: {
  user.packages = with pkgs; [flameshot];
  systemd.user.services."flameshot" = {
    enable = true;
    description = "";
    requires = ["tray.target"];
    wantedBy = ["graphical-session.target"];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.flameshot}/bin/flameshot";
  };
}
