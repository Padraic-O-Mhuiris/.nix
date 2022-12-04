{ config, lib, pkgs, ... }:

{
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    device = "nodev";
    theme = pkgs.nixos-grub2-theme;
  };
  boot.loader.efi.canTouchEfiVariables = true;
}
