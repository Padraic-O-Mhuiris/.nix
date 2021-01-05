{ config, lib, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  users.users.padraic.extraGroups = [ "docker" ];
  environment.systemPackages = with pkgs; [ docker docker-compose ];

}
