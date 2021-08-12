{ config, options, lib, pkgs, inputs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.tools.dapptools;

  dapptools = import (builtins.fetchFromGitHub {
    url = "https://github.com/dapphub/dapptools";
    rev = "b018508967657800e7e7c1d07e6e454c5e284feb";
    sha256 = "0jhlsm79vkq800ckx5ri9x7ybng0kf11s5rs32mlh9hnvlyxknzy";
    owner = "dapphub";
  }) { };

in {
  options.modules.desktop.tools.dapptools = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    user.packages = with pkgs; [ dapptools.hevm solc z3 cvc4 ];

  };
}
