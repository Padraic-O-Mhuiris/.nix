{ config, lib, pkgs, ... }:

{
  powerManagement.cpuFreqGovernor = "powersave";
  hardware.cpu.intel.updateMicrocode = true;
}
