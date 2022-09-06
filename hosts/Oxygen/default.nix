{ config, pkgs, lib, inputs, ... }:

{
  nix = { buildCores = 16; };

  imports = [ ./hardware-configuration.nix ];

  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.zfs.enableUnstable = true;
  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.devNodes = "/dev/disk/by-path";

  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "zfs.zfs_arc_max=12884901888" ];
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  powerManagement.enable = true;

  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    enableCryptodisk = false;
    device = "nodev";
    font = "${
        builtins.toPath pkgs.iosevka
      }/share/fonts/truetype/iosevka-regular.ttf";
    fontSize = 30;
    gfxmodeEfi = "5120x1440";
    gfxmodeBios = "5120x1440";
  };
}
