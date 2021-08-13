{ config, lib, pkgs, modulesPath, inputs, ... }:

let thinkpadX1Carbon = "${inputs.hardware}/lenovo/thinkpad/x1/7th-gen";
in {
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix") thinkpadX1Carbon ];

  modules.hardware = {
    audio.enable = true;
    grub.enable = true;
    fs.enable = true;
    bluetooth = {
      enable = true;
      audio.enable = true;
    };
    wallet.enable = true;
    printing.enable = true;
  };

  boot = {
    cleanTmpDir = true;
    kernel.sysctl = {
      "fs.file-max" = 100000;
      "fs.inotify.max_user_instances" = 256;
      "fs.inotify.max_user_watches" = 500000;
    };
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    loader = { efi.canTouchEfiVariables = true; };
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];

      luks.devices = {
        crypted = {
          device = "/dev/disk/by-uuid/11111111-1111-1111-1111-111111111111";
          preLVM = true;
        };
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/21061e63-fb76-4f09-b4e8-1f8e4f77549f";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/3970-761A";
      fsType = "vfat";
    };
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/3753c231-1a35-4c07-8145-79ff29be138b"; }];

  hardware.video.hidpi.enable = lib.mkDefault true;

  hardware = { cpu.intel.updateMicrocode = true; };

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  services = {
    fwupd.enable = true;
    hardware.bolt.enable = true;
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        USB_AUTOSUSPEND = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      };
    };
  };

}
