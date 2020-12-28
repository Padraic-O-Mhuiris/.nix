{ config, pkgs, lib, ... }:

{
  boot= {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        version = 2;
        efiSupport = true;
        enableCryptodisk = true;
        device = "nodev";
        fontSize = 30;
      };
    };
    initrd = {
      luks.devices = {
        enc-pv = {
          device = "/dev/disk/by-uuid/954da3dc-267e-4ad5-a15b-b5d3664f36f7";
          preLVM = true;
        };
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
