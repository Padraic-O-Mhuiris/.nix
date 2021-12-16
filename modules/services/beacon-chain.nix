{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let cfg = config.modules.services.beacon-chain;
in {
  options.modules.services.beacon-chain = { enable = mkBoolOpt false; };

  config =
    mkIf cfg.enable { user.packages = with pkgs; [ my.prysm-beacon-chain ]; };
}
