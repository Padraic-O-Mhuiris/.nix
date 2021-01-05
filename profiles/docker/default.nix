{ config, lib, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  users.users.padraic.extraGroups = [ "docker" ];
}
