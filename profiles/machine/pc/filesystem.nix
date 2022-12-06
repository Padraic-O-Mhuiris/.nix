{ config, lib, pkgs, ... }:

{
  fileSystems."/" = {
    device = "zroot/root/nixos";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "zroot/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A025-8EF4";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/38f4f51a-a1eb-47e9-80f7-ac46d49fa6d2"; }];
}
