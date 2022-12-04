{ config, lib, pkgs, ... }:

{

  boot.plymouth.enable = true;
  boot.plymouth.font =
    "${pkgs.iosevka}/share/fonts/truetype/iosevka-regular.ttf";
}
