{ config, lib, pkgs, ... }:
let
  spotify = pkgs.spotify.override {
    deviceScaleFactor =
      if config.networking.hostName == "Oxygen" then 1 else 1.25;
  };
in { user.packages = [ spotify pkgs.spotify-tray ]; }
