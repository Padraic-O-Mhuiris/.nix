{ config, lib, pkgs, ... }:

{
  imports = [ ./user.nix ./default.nix ./env.nix ];
}
