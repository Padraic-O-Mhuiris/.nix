{ config, lib, pkgs, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  hardware = {
    video.hidpi.enable = true;
    opengl.enable = true;
    nvidia = {
      package = pkgs.unstable.linuxPackages_latest.nvidiaPackages.latest;
      modesetting.enable = true;
      prime = {
        offload.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
      powerManagement = {
        enable = true;
        finegrained = true;
      };
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  user.packages = with pkgs; [ glxinfo nvtop nvidia-offload ];
}
