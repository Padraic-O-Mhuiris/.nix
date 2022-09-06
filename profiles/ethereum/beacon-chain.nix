{ config, lib, pkgs, ... }:

let
  beaconChainDir = "/var/lib/prysm/beacon";
  beaconChainPkg = (import ../../packages/prysmbeacon.nix {
    inherit pkgs;
    inherit lib;
  });

in {
  user.packages = [ beaconChainPkg ];

  users.extraUsers = {
    prysmbeacon = {
      isSystemUser = true;
      shell = null;
      hashedPassword = "*";
      home = beaconChainDir;
      group = "prysmbeacon";
    };
  };
  users.groups."prysmbeacon" = { };
  systemd.tmpfiles.rules =
    [ "d '${beaconChainDir}' 0700 prysmbeacon prysmbeacon - -" ];

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
        "${beaconChainPkg}/bin/prysmbeacon --datadir=${beaconChainDir} --execution-endpoint=http://localhost:8551 --p2p-max-peers=100 --log-format=journald --accept-terms-of-use --block-batch-limit 256 --suggested-fee-recipient=0xFB18b8F2bBE88c4C29ca5a12ee404DB4d640fe4E";
    };
  };
}
