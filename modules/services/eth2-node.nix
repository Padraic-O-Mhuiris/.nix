{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.services.eth2-node;
  beaconChainDir = "/var/lib/prysm/beacon";
in {
  options.modules.services.eth2-node = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ my.prysmbeacon my.prysmvalidator ];

    systemd.services.prysmbeacon = {
      description = "Prysm Eth2 Client Beacon Node";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "prysmbeacon";
        Group = "prysmbeacon";
        Restart = "always";
        RestartSec = "5";
        ExecStart =
          "${my.prysmbeacon} --datadir=${beaconChainDir} --http-web3provider=http://127.0.0.1:8545 --accept-terms-of-use";
      };
    };
  };
}
