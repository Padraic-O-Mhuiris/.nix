{ config, lib, ... }:

with lib; {
  networking.hosts = let
    hostConfig = { "192.168.0.26" = [ "Hydrogen" ]; };
    hosts = flatten (attrValues hostConfig);
    hostName = config.networking.hostName;
  in mkIf (builtins.elem hostName hosts) hostConfig;

  time.timeZone = mkDefault "Europe/Dubline";
  i18n.defaultLocale = mkDefault "en_IE.UTF-8";

  location = {
    latitude = 53.28;
    longitude = -9.03;
  };
}
