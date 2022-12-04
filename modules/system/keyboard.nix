{ config, lib, pkgs, ... }:

{
  services.xserver = {
    layout = "gb";
    libinput.enable = true;
    xkbOptions = "ctrl:swapcaps";
  };
}
