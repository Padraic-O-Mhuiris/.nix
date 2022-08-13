{ config, lib, pkgs, ... }:

{

  imports = [ ./networking.nix ];

  user.packages = with pkgs; [
    coreutils
    binutils
    gnumake
    gcc
    htop
    xclip
    clang
    pciutils
    bc
    vim
    i7z
    unzip
    tree
    jq
    lm_sensors
    cachix
    bind
    cached-nix-shell
    git
    wget
    gnumake
    iw
    nix-index
    patchelf
    stdenv.cc.cc.lib
    file
    libsecret
    zlib
  ];

}
