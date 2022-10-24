{
  config,
  lib,
  pkgs,
  ...
}: let
  spotify = pkgs.spotify.override {deviceScaleFactor = 1.25;};
in {user.packages = [spotify pkgs.spotify-tray];}
