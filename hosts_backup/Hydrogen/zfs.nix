{ config, pkgs, ... }: {
  boot.supportedFilesystems = [ "zfs" ];
  networking.hostId = "3f90d23a";
  boot = {
    loader = {
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = false;
      };
      generationsDir.copyKernels = true;
      grub = {
        efiInstallAsRemovable = true;
        enable = true;
        version = 2;
        copyKernels = true;
        efiSupport = true;
        zfsSupport = true;
        font = "${
            builtins.toPath pkgs.iosevka
          }/share/fonts/truetype/iosevka-regular.ttf";
        fontSize = 30;
        gfxmodeEfi = "3840x2400";
        gfxmodeBios = "3840x2400";
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
      };
    };
  };
}
