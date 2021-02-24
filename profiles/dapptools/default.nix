{ config, lib, pkgs, inputs, ... }:

let inherit (inputs) dapptools;
in {

  nix = {
    binaryCaches = [ "https://dapp.cachix.org" ];
    binaryCachePublicKeys =
      [ "dapp.cachix.org-1:9GJt9Ja8IQwR7YW/aF0QvCa6OmjGmsKoZIist0dG+Rs=" ];
  };

  # environment.systemPackages = with dapptools; [ seth ];

  #home-manager.users.padraic = {
  #  home.packages = with dapptools; [ seth dapp ];
  #};
}
