{ config, lib, pkgs, inputs, ... }:

let
  thinkpadX1Carbon = "${inputs.hardware}/lenovo/thinkpad/x1/7th-gen";
in {

  imports = [
   thinkpadX1Carbon 
  ];

  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
  };

  services = {
    fwupd.enable = true;
    hardware.bolt.enable = true;
    thermald.enable = true;
    blueman.enable = true;
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
