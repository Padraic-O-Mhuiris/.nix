{ config, lib, pkgs, ... }:

{
  sops.defaultSopsFile = "./secrets.yaml";
  sops.gnupgHome = "/var/lib/sops";
  sops.sshKeyPaths = [];
}
