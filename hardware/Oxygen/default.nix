{ config, lib, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./filesystem.nix
    ./gui.nix
    ./kernel.nix
    ./networking.nix
    ./zfs.nix
    ../common/keyboard.nix
  ];

  nix.settings.cores = 32;

  system.stateVersion = "22.05";
}
