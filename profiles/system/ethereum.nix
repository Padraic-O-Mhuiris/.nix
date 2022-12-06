{ config, lib, pkgs, ... }:

let
  beaconChainDir = "/var/lib/prysm/beacon";
  beaconChainPkg = import ../../packages/prysmbeacon.nix { inherit pkgs; };

  validatorDir = "/var/lib/prysm/validator";
  validatorPkg = import ../../packages/prysmvalidator.nix { inherit pkgs; };
in {

  sops.secrets = {
    jwt = {
      mode = "0440";
      restartUnits = [ "prysmbeacon.service" "prysmvalidator.service" ];
    };
    walletPassword = {
      restartUnits = [ "prysmvalidator.service" ];
      mode = "0440";
    };
  };

  systemd.tmpfiles.rules = [
    "d '${validatorDir}' 0700 prysmvalidator prysmvalidator - -"
    "d '${beaconChainDir}' 0700 prysmbeacon prysmbeacon - -"
  ];

  ##### GETH ####
  services.geth = {
    mainnet = {
      enable = true;
      http = {
        enable = true;
        apis = [ "net" "eth" "debug" "engine" "admin" ];
        port = 8545;
      };
      authrpc = {
        enable = true;
        jwtsecret = config.sops.secrets.jwt.path;
      };
      metrics.enable = false;
      syncmode = "full";
      package = pkgs.unstable.go-ethereum.geth;
    };
  };

  ##### BEACON ####
  environment.systemPackages = [ beaconChainPkg ];

  users.extraUsers = {
    prysmbeacon = {
      isSystemUser = true;
      shell = null;
      hashedPassword = null;
      home = beaconChainDir;
      group = "prysmbeacon";
    };
  };

  users.groups."prysmbeacon" = { };

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
        "${beaconChainPkg}/bin/prysmbeacon --datadir=${beaconChainDir} --execution-endpoint=http://localhost:8551 --p2p-max-peers=100 --log-format=journald --accept-terms-of-use --block-batch-limit 256 --suggested-fee-recipient=0xFB18b8F2bBE88c4C29ca5a12ee404DB4d640fe4E --jwt-secret=${config.sops.secrets.jwt.path}";
      SupplementaryGroups = [ config.users.groups.keys.name ];
    };
  };

  ##### VALIDATOR ####

  users.extraUsers = {
    prysmvalidator = {
      isSystemUser = true;
      shell = null;
      hashedPassword = null;
      home = validatorDir;
      group = "prysmvalidator";
    };
  };

  users.groups."prysmvalidator" = { };

  systemd.services.prysmvalidator = {
    description = "Prysm Eth2 Validator Client";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "prysmvalidator";
      Group = "prysmvalidator";
      Type = "simple";
      Restart = "always";
      RestartSec = "5";
      ExecStart =
        "${validatorPkg}/bin/prysmvalidator --datadir=${validatorDir} --wallet-dir=${validatorDir}/wallet --wallet-password-file=${config.sops.secrets.walletPassword.path} --accept-terms-of-use --suggested-fee-recipient=0xFB18b8F2bBE88c4C29ca5a12ee404DB4d640fe4E";
      SupplementaryGroups = [ config.users.groups.keys.name ];
    };
  };
}
