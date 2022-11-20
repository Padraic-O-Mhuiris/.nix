{ config, lib, pkgs, ... }:

{
  hardware = {
    video.hidpi.enable = true;
    opengl.enable = true;
    nvidia.modesetting.enable = false;
    nvidia.prime.offload.enable = true;
    nvidia.prime.nvidiaBusId = "PCI:1:0:0";
    nvidia.prime.intelBusId = "PCI:0:2:0";
    nvidia.powerManagement.enable = true;
    nvidia.powerManagement.finegrained = true;
  };
  user.packages = with pkgs; [ glxinfo nvtop ];
}
