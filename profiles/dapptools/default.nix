{ config, lib, pkgs, inputs, ... }:

let inherit (inputs) dapptools;
in {

  environment.systemPackages = with pkgs; [ dapptools.seth dapptools.dapp ];

  #home-manager.users.padraic = {
  #  home.packages = with dapptools; [ seth dapp ];
  #};
}
