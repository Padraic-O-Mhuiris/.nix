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
      # authrpc = {
      #   enable = true;
      #   jwtSecret = config.age.secrets.jwt.path;
      # };
      metrics.enable = false;
      syncmode = "full";
      package = pkgs.unstable.go-ethereum.geth; # always use latest
    };
  };
  users.users."geth-mainnet" = {
    group = "geth-mainnet";
    isSystemUser = true;
    extraGroups = [ "ethereum" ];
  };
}
