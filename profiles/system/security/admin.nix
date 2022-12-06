{ config, lib, pkgs, ... }:

{
  #security.doas.enable = true;
  #security.sudo.enable = false;
  security.polkit.enable = true;
}
