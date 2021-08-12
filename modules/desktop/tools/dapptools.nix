{ config, options, lib, pkgs, inputs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.tools.dapptools;
  dapptools = inputs.dapptools;
in {
  options.modules.desktop.tools.dapptools = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    user.packages = with pkgs; [ solc z3 cvc4 ];

  };
}
