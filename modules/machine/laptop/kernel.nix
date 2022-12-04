{ config, lib, pkgs, ... }:

{
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  #boot.kernelPackages = config.os.machine.kernel;
}
