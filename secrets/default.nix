{ config, lib, pkgs, ... }:

{
  #environment.systemPackages = with pkgs; [ sops age ];
  sops.defaultSopsFile = ./secrets.yaml;
}
