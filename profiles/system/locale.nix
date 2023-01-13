{ config, lib, pkgs, ... }:

{
  services.ntp.enable = true;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_IE.UTF-8";

  location = {
    latitude = 53.28;
    longitude = -9.03;
  };
}
