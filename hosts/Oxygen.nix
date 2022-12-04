{ config, lib, pkgs, ... }:

{
  imports = [
    ../modules/machine/pc/monitors.nix
    ../modules/machine/pc/filesystem.nix
    ../modules/machine/pc/zfs.nix
    ../modules/machine/pc/boot.nix

    ../modules/machine/nvidia.nix

    ../modules/system/aliases.nix
    ../modules/system/audio.nix
    ../modules/system/bluetooth.nix
    ../modules/system/keyboard.nix
    ../modules/system/networking.nix
    ../modules/system/ssh.nix
    ../modules/system/virtualisation.nix

    ../modules/system/security/admin.nix
    ../modules/system/security/antivirus.nix
    ../modules/system/security/firewall.nix
    ../modules/system/security/hardened.nix

    ../modules/ui/boot.nix
    ../modules/ui/cli.nix
    ../modules/ui/fonts.nix
    ../modules/ui/launcher.nix
    ../modules/ui/login.nix
    ../modules/ui/wm.nix

    ../modules/user/padraic
  ];

  time.timeZone = "Europe/Dublin";
  i18n.defaultLocale = "en_IE.UTF-8";

  location = {
    latitude = 53.28;
    longitude = -9.03;
  };

  system.stateVersion = "22.05";
}
