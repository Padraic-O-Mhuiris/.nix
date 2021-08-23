{ config, pkgs, lib, ... }:

with lib;
with lib.my; {
  networking.hosts = let
    hostConfig = { "192.168.0.26" = [ "Hydrogen" ]; };
    hosts = flatten (attrValues hostConfig);
    hostName = config.networking.hostName;
  in mkIf (builtins.elem hostName hosts) hostConfig;

  time.timeZone = mkDefault "Europe/Dublin";
  i18n.defaultLocale = mkDefault "en_IE.UTF-8";

  location = {
    latitude = 53.28;
    longitude = -9.03;
  };

  networking = {
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "9.9.9.9" ];
  };

  programs.nm-applet.enable = true;

  user.packages = with pkgs; [
    coreutils
    binutils
    gnumake
    gcc
    htop
    xclip
    clang
    bc
    vim
    i7z
    unzip
    tree
    glxinfo
    jq
    lm_sensors
    cachix
    niv
    zoom
  ];
}
