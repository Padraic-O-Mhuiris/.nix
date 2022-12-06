{ config, lib, pkgs, ... }:

with lib;

mkMerge [
  {
    networking = {
      networkmanager.enable = true;
      nameservers = [ "1.1.1.1" "9.9.9.9" ];
      hosts = { "127.0.0.1" = [ config.networking.hostName ]; };
    };
  }
  (mkIf config.os.ui.active { programs.nm-applet.enable = true; })
]
