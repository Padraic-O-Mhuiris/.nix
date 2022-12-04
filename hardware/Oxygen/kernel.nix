{ config, lib, pkgs, ... }:

{
  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelPackages = config.os.machine.kernel;
  hardware.cpu.amd.updateMicrocode = true;
}
