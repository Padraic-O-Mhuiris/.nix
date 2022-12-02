{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    htop
    bc
    iw
    coreutils
    binutils
    pciutils
    unzip
    tree
    exa
    bat
    lm_sensors
    jq
    steam-run
    dconf
  ];
}
