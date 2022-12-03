{ config, lib, pkgs, ... }:

{
  boot.plymouth.enable = true;
  boot.plymouth.font =
    "${pkgs.iosevka}/share/fonts/truetype/iosevka-regular.ttf";
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    device = "nodev";
    theme = pkgs.nixos-grub2-theme;
  };
  boot.loader.efi.canTouchEfiVariables = true;
}
