{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.hardware.grub;
  mode = if config.modules.desktop.monitors.enable then
    config.modules.desktop.monitors.mode
  else
    "1280x800";
in {
  options.modules.hardware.grub = {
    enable = mkBoolOpt false;
    luks = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    console = {
      font = "ter-v32b";
      keyMap = "uk";
    };

    boot.loader.grub = {
      enable = true;
      version = 2;
      efiSupport = true;
      enableCryptodisk = luks;
      device = "nodev";
      font = "${
          builtins.toPath pkgs.iosevka
        }/share/fonts/truetype/iosevka-regular.ttf";
      fontSize = 30;
      gfxmodeEfi = mode;
      gfxmodeBios = mode;
    };
  };
}
