{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [ age sops ];
  sops.defaultSopsFile = ./secrets.yaml;
}
