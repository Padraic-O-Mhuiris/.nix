{ config, lib, pkgs, ... }:

{
  services.xserver = {
    layout = "gb";
    libinput.enable = true;
    xkbOptions = "ctrl:swapcaps";
  };
  programs.light.enable = true;

  user.groups = [ "video" ];
}
