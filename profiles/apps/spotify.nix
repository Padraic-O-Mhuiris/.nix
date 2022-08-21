{ config, lib, pkgs, ... }:

{
  user.packages = with pkgs; [
    spotify
    (makeDesktopItem {
      name = "Spotify";
      desktopName = "Spotify";
      genericName = "Music Player";
      icon = "Spotify";
      exec = "${spotify}/bin/spotify  --force-device-scale-factor=1.5";
      categories = [ "Network" "Music" ];
    })
  ];
}
