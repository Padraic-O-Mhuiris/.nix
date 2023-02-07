{ config, lib, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu.ovmf.enable = true;
  };

  os.user.groups = [ "docker" ];

  os.user.packages = with pkgs;
    [ nodePackages_latest.dockerfile-language-server-nodejs ];
}
