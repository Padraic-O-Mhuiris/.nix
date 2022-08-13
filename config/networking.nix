{ config, lib, pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "9.9.9.9" ];
  };

  programs.nm-applet.enable = true;
}
