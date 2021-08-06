{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;

let cfg = config.modules.desktop.tools.dapptools;
in {
  options.modules.desktop.tools.dapptools = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    user.packages = with pkgs; [ solc z3 cvc4 ];

  };
}
