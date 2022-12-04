{ config, lib, pkgs, ... }:

{
  imports = [
    ../modules/machine/pc/monitors.nix
    ../modules/machine/pc/filesystem.nix
    ../modules/machine/pc/zfs.nix
    ../modules/machine/pc/boot.nix
    ../modules/machine/pc/networking.nix

    ../modules/machine/nvidia.nix
  ];

  system.stateVersion = "22.05";
}
