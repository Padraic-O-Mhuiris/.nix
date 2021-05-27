{ config, lib, inputs, pkgs, ... }:

{
  imports = [ <inputs/sops-nix/modules/sops> ];

  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  # sops.defaultSopsFile = "/root/.sops/secrets.yaml";
  sops.defaultSopsFile = ../../secrets.yaml;
  sops.secrets.secret = {};
} 
