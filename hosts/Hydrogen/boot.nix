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
        crypted = {
          device = "/dev/disk/by-uuid/11111111-1111-1111-1111-111111111111";
          preLVM = true;
        };
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    #extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };
}
