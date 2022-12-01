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
  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [ glxinfo nvtop nvidia-offload ];

  hardware = {
    video.hidpi.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      package = pkgs.master.linuxPackages_latest.nvidiaPackages.latest;
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

  services.xserver.xrandrHeads = let
    HDMI-monitor = "HDMI-0";
    DP-monitor = "DP-0";
  in [
    {
      output = DP-monitor;
      primary = true;
    }
    {
      output = HDMI-monitor;
      monitorConfig = ''
        Option "LeftOf" "${DP-monitor}"
        Option "Rotate" "right"
      '';
    }
  ];
}
