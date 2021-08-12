{ config, options, lib, pkgs, inputs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.tools.dapptools;

  dapptools = import (inputs.dapptools) { };

in {
  options.modules.desktop.tools.dapptools = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    user.packages = with pkgs;
      with dapptools; [
        hevm
        seth
        dapp
        ethsign
        solc
        z3
        cvc4
      ];

  };
}
