{ config, options, lib, pkgs, inputs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.shell.dapptools;

  dapptools = import (inputs.dapptools) { system = "x86_64-linux"; };

in {
  options.modules.shell.dapptools = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    home.configFile."seth/sethrc".text = ''
      export ETH_FROM=0x0000000000000000000000000000000000000000
      export ETH_RPC_URL=https://localhost:9000
    '';

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
