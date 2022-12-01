{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ spotify pkgs.spotify-tray ];
}
