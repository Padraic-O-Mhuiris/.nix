{ config, lib, pkgs, ... }:

{
  imports = [
    ./emacs.nix
    ./firewall.nix
    ./virtualisation.nix
    ../common/user.nix
    ../common/settings.nix
    ../common/ssh.nix
    ../common/audio.nix
    ../common/security.nix
    ../common/location.nix
    ../common/docker.nix
  ];
}
