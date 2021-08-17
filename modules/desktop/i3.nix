{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.i3;
in {
  options.modules.desktop.i3 = {
    enable = mkBoolOpt false;
    dpi = mkOpt (with types; int) 180;
  };

  config = mkIf cfg.enable {
    environment.pathsToLink = [ "/libexec" ];

    user.packages = with pkgs; [
      lightdm
      dunst
      libnotify
      (polybar.override {
        pulseSupport = true;
        nlSupport = true;
      })
    ];

    services.xserver = {
      picom.enable = true;
      enable = true;
      dpi = cfg.dpi;
      displayManager = {
        defaultSession = "none+i3";
        autoLogin = {
          enable = true;
          user = config.user.name;
        };
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        configFile = ../../config/i3/config;
        extraPackages = with pkgs; [
          dmenu # application launcher most people use
          i3status # gives you the default i3 status bar
          i3lock # default i3 screen locker
          i3blocks # if you are planning on using i3blocks over i3status
        ];
      };
    };

    systemd.user.services."dunst" = {
      enable = true;
      description = "";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
    };

  };
}
