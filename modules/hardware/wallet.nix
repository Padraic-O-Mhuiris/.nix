{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.wallet;
in {
  options.modules.hardware.wallet = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    # For crypto wallets
    hardware.ledger.enable = true;
  };
}
