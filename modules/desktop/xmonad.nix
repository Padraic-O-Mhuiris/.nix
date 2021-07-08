{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.i3;
in {
  options.modules.desktop.xmonad = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.pathsToLink = [ "/libexec" ];
    services.xserver = {
      enable = true;
      displayManager = { defaultSession = "none+xmonad"; };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages =
          hpkgs: [ # Open configuration for additional Haskell packages.
            hpkgs.xmonad-contrib # Install xmonad-contrib.
            hpkgs.xmonad-extras # Install xmonad-extras.
            hpkgs.xmonad # Install xmonad itself.
          ];
        config = ../../config/xmonad/config.hs;
      };
    };
  };
}
