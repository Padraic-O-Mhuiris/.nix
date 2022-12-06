{ config, lib, pkgs, ... }:

{
  services.xserver.xrandrHeads = let
    HDMI-monitor = "HDMI-0";
    DP-monitor = "DP-0";
  in [
    {
      output = DP-monitor;
      primary = true;
    }
    {
      output = HDMI-monitor;
      monitorConfig = ''
        Option "LeftOf" "${DP-monitor}"
        Option "Rotate" "right"
      '';
    }
  ];
}
