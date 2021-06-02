{ config, lib, pkgs, ... }:

{
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.gnupgHome = "/home/padraic/.gnupg";
  sops.sshKeyPaths = [];
}
