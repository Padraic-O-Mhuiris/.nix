{ config, lib, pkgs, ... }:

let
  i3Config = pkgs.writeTextFile {
    name = "i3Config";
    executable = true;
    destination = "/bin/i3Config";
    text = "";
  };
in {

  environment.pathsToLink = [ "/libexec" ];
  services = {
    xserver = {
      enable = true;
      dpi = 180;
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
        configFile = i3Config;
        extraPackages = with pkgs; [
          dmenu # application launcher most people use
          i3status # gives you the default i3 status bar
          i3lock # default i3 screen locker
          i3blocks # if you are planning on using i3blocks over i3status
        ];
      };
    };
  };

}
