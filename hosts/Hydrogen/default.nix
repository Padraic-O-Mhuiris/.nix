{ config, pkgs, lib, inputs, ... }: {
  nix.settings.cores = 32;

  imports = [ ./hardware-configuration.nix ./zfs.nix ./nvidia.nix ];
  time.timeZone = "Europe/Dublin";
  i18n.defaultLocale = "en_IE.UTF-8";

  location = {
    latitude = 53.28;
    longitude = -9.03;
  };

  system.stateVersion = "22.05";
}
