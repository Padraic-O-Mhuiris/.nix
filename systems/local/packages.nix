{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    libreoffice
    firefox
    qbittorrent
    vlc
    xclip
    bitwarden
    tdesktop
  ];
}
