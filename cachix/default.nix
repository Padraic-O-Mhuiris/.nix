{ config, lib, pkgs, ... }:

{
  nix = { binaryCaches = [ "https://cache.nixos.org" ]; };
}
