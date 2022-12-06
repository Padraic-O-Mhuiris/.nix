{ config, lib, pkgs, ... }:

let
  spotify = pkgs.spotify.override {
    deviceScaleFactor =
      if config.networking.hostName == "Oxygen" then 1 else 1.25;
  };
in { os.user.packages = with pkgs; [ spotify spotify-tray ]; }
