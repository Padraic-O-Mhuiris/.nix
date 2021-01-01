{ config, lib, pkgs, inputs, ... }:

let inherit (inputs) dapptools;
in {
  home-manager.users.padraic = {
    home.packages = with pkgs; [ dapptools.seth dapptools.dapp ];
  };
}
