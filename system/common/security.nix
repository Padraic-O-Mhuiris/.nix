{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/profiles/hardened.nix" ];
  services.dbus.apparmor = "enabled";
  services.dbus.packages = with pkgs; [ dconf ];

  #security.doas.enable = true;
  #security.sudo.enable = false;
  security.polkit.enable = true;

  services.clamav = {
    daemon.enable = true;
    updater = {
      enable = true;
      frequency = 4;
    };
  };

  systemd.coredump.enable = false;
}
