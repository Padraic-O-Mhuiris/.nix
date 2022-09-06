{ config, lib, pkgs, ... }:

{
  services.geth = {
    mainnet = {
      enable = true;
      http = {
        enable = true;
        apis = [ "net" "eth" "debug" "engine" "admin" ];
        port = 8551;
      };
      metrics.enable = false;
      syncmode = "full";
      package = pkgs.unstable.go-ethereum.geth; # always use latest
    };
  };
}
