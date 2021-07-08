{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.redshift;
in {
  options.modules.desktop.redshift = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.redshift = {
      enable = true;
      brightness = {
        # Note the string values below.
        day = "1";
        night = "1";
      };
      temperature = {
        day = 5500;
        night = 3700;
      };
    };

  };
}
