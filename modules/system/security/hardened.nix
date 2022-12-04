{ modulesPath, config, lib, pkgs, ... }:

{
  imports = [ "${modulesPath}/profiles/hardened.nix" ];
  services.dbus.apparmor = "enabled";
  services.dbus.packages = with pkgs; [ dconf ];

  systemd.coredump.enable = false;
}
