{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let cfg = config.modules.services.beacon-chain;
in {
  options.modules.services.geth = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { user.packages = [ prysm-beacon-chain ]; };
}
