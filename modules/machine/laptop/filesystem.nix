{ config, lib, pkgs, ... }:

{
  fileSystems."/" = {
    device = "rpool/nixos/root";
    fsType = "zfs";
    options = [ "zfsutil" "X-mount.mkdir" ];
  };

  fileSystems."/home" = {
    device = "rpool/nixos/home";
    fsType = "zfs";
    options = [ "zfsutil" "X-mount.mkdir" ];
  };

  fileSystems."/var/lib" = {
    device = "rpool/nixos/var/lib";
    fsType = "zfs";
    options = [ "zfsutil" "X-mount.mkdir" ];
  };

  fileSystems."/var/log" = {
    device = "rpool/nixos/var/log";
    fsType = "zfs";
    options = [ "zfsutil" "X-mount.mkdir" ];
  };

  fileSystems."/boot" = {
    device = "bpool/nixos/root";
    fsType = "zfs";
    options = [ "zfsutil" "X-mount.mkdir" ];
  };

  fileSystems."/boot/efis/pci-0000:02:00.0-nvme-1-part1" = {
    device = "/dev/disk/by-uuid/77B8-65C6";
    fsType = "vfat";
  };

  fileSystems."/boot/efi" = {
    device = "/boot/efis/pci-0000:02:00.0-nvme-1-part1";
    fsType = "none";
    options = [ "bind" ];
  };

  swapDevices = [ ];

}
