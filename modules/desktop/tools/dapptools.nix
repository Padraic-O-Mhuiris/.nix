{ config, options, lib, pkgs, inputs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.tools.dapptools;

  dapptools = import (builtins.fetchGit rec {
    name = "dapptools-${rev}";
    url = "https://github.com/dapphub/dapptools";
    rev = "3e62bd54dfbc23b76d9234f94a7387504b360d5d";
    ref = "dapp/0.25.0";
  }) { };

in {
  options.modules.desktop.tools.dapptools = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    user.packages = with pkgs; [ dapptools.hevm solc z3 cvc4 ];

  };
}
