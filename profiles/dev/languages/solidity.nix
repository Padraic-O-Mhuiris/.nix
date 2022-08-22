{ config, lib, pkgs, ... }:

{
  user.packages = with pkgs; [ solc (import ../../packages/foundry.nix) ];
}
