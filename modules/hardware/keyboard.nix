{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.keyboard;
in {
  options.modules.hardware.keyboard = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.xserver = {
      layout = "gb";
      libinput.enable = true;
    };
    xkbOptions = "ctrl:swapcaps";
  };
}
