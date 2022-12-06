{ config, lib, pkgs, ... }:

with lib;
with lib.os;

{
  options.os.system = { isDesktop = mkOpt types.bool false; };

  config = {
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
      zlib
    ];
  };
}
