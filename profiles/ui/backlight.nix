{ config, lib, pkgs, ... }:

with lib;
with lib.os;

{
  options.os.ui.backlight = {
    day = mkOpt types.number 1;
    night = mkOpt types.number 0.5;
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
        day = config.os.ui.backlight.day * 5000;
        night = config.os.ui.backlight.night * 5000;
      };
    };

  };
  #programs.light.enable = true;
}
