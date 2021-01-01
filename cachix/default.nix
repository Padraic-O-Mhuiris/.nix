{ config, lib, pkgs, ... }:

{
  nix = {
    binaryCaches = [ "https://cache.nixos.org" "https://dapp.cachix.org" ];
    binaryCachePublicKeys =
      [ "dapp.cachix.org-1:9GJt9Ja8IQwR7YW/aF0QvCa6OmjGmsKoZIist0dG+Rs=" ];
  };
}
