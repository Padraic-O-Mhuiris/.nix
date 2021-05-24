{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./fonts.nix
    ./boot.nix
  ];
  networking = {
    hostName = "Nitrogen";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      enp5s0.useDHCP = true;
      wlp4s0.useDHCP = true;
    };
  };

  i18n = { defaultLocale = "en_IE.UTF-8"; };
  console = {
    font = "latarcyrheb-sun32";
    keyMap = "uk";
  };

}
