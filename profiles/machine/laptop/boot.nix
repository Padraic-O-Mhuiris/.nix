{ config, lib, pkgs, ... }:

{
  networking.hostId = "3f90d23a";
  boot = {
    supportedFilesystems = [ "zfs" ];
    loader = {
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = false;
      };
      grub = {
        enable = true;
        efiInstallAsRemovable = true;
        version = 2;
        copyKernels = true;
        efiSupport = true;
        zfsSupport = true;
        extraPrepareConfig = ''
          mkdir -p /boot/efis
          for i in  /boot/efis/*; do mount $i ; done

          mkdir -p /boot/efi
          mount /boot/efi
        '';
        extraInstallCommands = ''
          ESP_MIRROR=$(mktemp -d)
          cp -r /boot/efi/EFI $ESP_MIRROR
          for i in /boot/efis/*; do
           cp -r $ESP_MIRROR/EFI $i
          done
          rm -rf $ESP_MIRROR
        '';
        devices = [ "/dev/disk/by-path/pci-0000:02:00.0-nvme-1" ];
        theme = pkgs.nixos-grub2-theme;
      };
    };
  };
}
