{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.grub;
in {
  options.modules.hardware.grub = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    boot.loader.grub = {
      enable = true;
      version = 2;
      efiSupport = true;
      enableCryptodisk = true;
      device = "nodev";
      font = "${
          builtins.toPath pkgs.iosevka
        }/share/fonts/truetype/iosevka-regular.ttf";
      fontSize = 30;
      gfxmodeEfi = "1280x800";
      gfxmodeBios = "1280x800";
    };
  };
}
