{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.i3;
in {
  options.modules.desktop.i3 = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.pathsToLink = [ "/libexec" ];
    services.xserver = {
      enable = true;
      displayManager = {
        defaultSession = "none+i3";
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
	configFile = ../../config/i3/config;
        extraPackages = with pkgs; [
          dmenu #application launcher most people use
          i3status # gives you the default i3 status bar
          i3lock #default i3 screen locker
          i3blocks #if you are planning on using i3blocks over i3status
        ];
      };
    };
  };
}
