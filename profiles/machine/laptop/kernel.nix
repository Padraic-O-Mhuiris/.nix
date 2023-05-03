{ config, lib, pkgs, ... }:

{
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  # https://discourse.nixos.org/t/cant-get-nixos-on-xps-15-9520-to-boot/23600/2?u=padraic-o-mhuiris
  boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];

}
