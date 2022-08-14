{ config, lib, pkgs, ... }:

{
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
    binaryCaches =
      [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    trustedUsers = [ "${config.user.name}" ];
    allowedUsers = [ "${config.user.name}" ];
  };

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
