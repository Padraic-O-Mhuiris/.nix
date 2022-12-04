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
    ../modules/ui/fonts.nix
    ../modules/ui/login.nix
    ../modules/ui/wm.nix

    ../modules/user/padraic
  ];

  system.stateVersion = "22.05";
}
