{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.services.geth;
  configDir = config.dotfiles.configDir;
in {
  options.modules.services.geth = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    services.geth = {
      mainnet = {
        enable = true;
        http = {
          enable = true;
          apis = [ "net" "eth" ];
        };
        websocket = {
          enable = true;
          apis = [ "net" "eth" ];
        };
        metrics.enable = true;
        syncmode = "full";
      };
    };

    services.prometheus = { enable = true; };
  };
}
