{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ sops ];
  sops.defaultSopsFile = ./secrets.yaml;
}
