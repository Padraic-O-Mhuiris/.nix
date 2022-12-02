{ config, lib, pkgs, ... }:

{
  imports = [
    ./displayManager.nix
    ./firewall.nix
    ./fonts.nix
    ./keyboard.nix
    ./ledger.nix
    ./packages.nix
    ./spotify.nix
    ./steam.nix
    ./virtualisation.nix

    ../common/audio.nix
    ../common/docker.nix
    ../common/location.nix
    ../common/packages.nix
    ../common/security.nix
    ../common/settings.nix
    ../common/ssh.nix
    ../common/user.nix

    ../dev/javascript.nix
    ../dev/python.nix
    ../dev/rust.nix
    ../dev/solidity.nix
  ];
}
