{ config, lib, pkgs, ... }:

with lib;
with lib.os;

{
  options.os.ui.backlight = {
    day = mkOpt types.float 1.0;
    night = mkOpt types.float 0.5;

  };

  config = {

    services.geoclue2.enable = true;
    services.geoclue2.appConfig.redshift.isAllowed = true;

    services.redshift = {
      enable = true;
      brightness = {
        day = builtins.toString config.os.ui.backlight.day;
        night = builtins.toString config.os.ui.backlight.night;
      };
      temperature = {
        day = 5000;
        night = 3000;
      };
    };

  };
  #programs.light.enable = true;
}
