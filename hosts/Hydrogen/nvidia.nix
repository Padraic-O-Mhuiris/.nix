{ config, lib, pkgs, ... }:

{
  hardware = {
    video.hidpi.enable = true;
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };
  user.packages = with pkgs; [ glxinfo nvtop ];
}
