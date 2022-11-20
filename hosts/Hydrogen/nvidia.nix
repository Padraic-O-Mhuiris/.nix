{ config, lib, pkgs, ... }:

{
  hardware = {
    video.hidpi.enable = true;
    opengl.enable = true;
    nvidia = {
      modesetting.enable = true;
      prime = {
        sync.enable = true;
        offload.enable = false;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  boot.kernelParams =
    [ "module_blacklist=i915" ]; # blocks intel integrated graphics
}
