{ config, lib, pkgs, ... }:

{
  services.picom = {
    enable = true;
    fade = true;
    fadeDelta = 1;
    fadeSteps = [ 1.0e-2 1.2e-2 ];
    shadow = true;
    shadowOffsets = [ (-10) (-10) ];
    shadowOpacity = 0.22;
    activeOpacity = 1.0;
    inactiveOpacity = 0.92;
    settings = {
      shadow-radius = 12;
      # blur-background = true;
      # blur-background-frame = true;
      # blur-background-fixed = true;
      blur-kern = "7x7box";
      blur-strength = 320;
    };
  };
}
