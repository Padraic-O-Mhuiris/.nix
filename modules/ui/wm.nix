{ config, lib, pkgs, ... }:

{
  os.ui.active = true;

  services.xserver.enable = true;
}
