{ config, lib, pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "9.9.9.9" ];
    hosts = { "127.0.0.1" = [ config.network.hostname ]; };
  };

  programs.nm-applet.enable = true;
}
