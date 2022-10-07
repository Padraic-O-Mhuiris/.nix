{ config, lib, pkgs, ... }:

{
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      substituters =
        [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      trusted-users = [ "${config.user.name}" ];
      allowed-users = [ "${config.user.name}" ];
    };
  };

  programs.nix-ld.enable = true;

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

    # TODO Move
    qbittorrent
    vlc
  ];
}
