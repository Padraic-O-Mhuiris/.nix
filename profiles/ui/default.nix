{ config, lib, pkgs, ... }:

{
  imports = [ ./i3.nix ./picom.nix ./loginManager.nix ./rofi.nix ];
}
