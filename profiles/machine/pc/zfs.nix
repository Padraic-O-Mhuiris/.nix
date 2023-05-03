{ config, lib, pkgs, ... }:

{
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.enableUnstable = false;
  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.devNodes = "/dev/disk/by-path";
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "zfs.zfs_arc_max=12884901888" ];

  networking.hostId = "ae2be7a7";
}
