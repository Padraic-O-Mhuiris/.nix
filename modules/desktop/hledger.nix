{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.hledger;
in {
  options.modules.desktop.hledger = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ unstable.nodePackages.beancount-langserver ];
    env = { LEDGER_FILE = "$HOME/.finance/fiat.ledger"; };
  };
}
