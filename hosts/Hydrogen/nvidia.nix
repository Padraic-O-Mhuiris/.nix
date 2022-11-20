{ config, lib, pkgs, ... }:

{
  hardware = {
    video.hidpi.enable = true;
    opengl.enable = true;
    nvidia = {
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      modesetting.enable = true;
      prime = {
        sync.enable = true;
        offload.enable = false;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    displayManager.setupCommands = "";
  };

  user.packages = with pkgs; [ glxinfo nvtop ];
}
