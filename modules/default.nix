{ config, lib, pkgs, ... }:

{
  imports = [ ./user.nix ./home.nix ./env.nix ];
}
