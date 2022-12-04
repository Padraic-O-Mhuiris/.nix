{ config, lib, pkgs, ... }:

{
  networking.hostId = "ae2be7a7";

  hardware.bluetooth = {
    enable = true;
    settings = { General.Enable = "Source,Sink,Media,Socket"; };
  };

  services.blueman.enable = true;

  networking = {
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "9.9.9.9" ];
    hosts = { "127.0.0.1" = [ config.networking.hostName ]; };
  };
}
