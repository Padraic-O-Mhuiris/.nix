{ config, lib, pkgs, ... }:

with lib;
with lib.os;

{
  options.os.system = { isDesktop = mkOpt types.bool false; };

  config = {
    environment.systemPackages = with pkgs; [
      bat
      bc
      bind
      binutils
      coreutils
      clang
      cached-nix-shell
      cachix
      dmidecode
      exa
      gcc
      gnumake
      git
      file
      htop
      libsecret
      libgcc
      libgccjit
      i7z
      iw
      jq
      lm_sensors
      nix-index
      pciutils
      patchelf
      stdenv.cc.cc.lib
      tree
      unzip
      vim
      wget
      xclip
      zlib
    ];
  };
}
