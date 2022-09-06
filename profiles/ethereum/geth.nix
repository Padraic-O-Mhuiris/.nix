{ config, lib, pkgs, nixpkgs-unstable, ... }:

{
  services.geth = {
    mainnet = {
      enable = true;
      http = {
        enable = true;
        apis = [ "net" "eth" "debug" "engine" "admin" ];
        port = 8545;
      };
      metrics.enable = false;
      syncmode = "full";
      package = pkgs.unstable.go-ethereum.geth;
      extraArgs = [ "--authrpc.jwtsecret ${config.age.secrets.jwt.path}" ];
    };
  };
}
