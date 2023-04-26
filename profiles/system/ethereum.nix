{ config, lib, pkgs, inputs, ... }:

let
  beaconChainDir = "/var/lib/prysm/beacon";
  validatorDir = "/var/lib/prysm/validator";
  prysm = inputs.ethereum.packages.${pkgs.system}.prysm;
in {
  environment.systemPackages = [ prysm ];

  sops.secrets = {
    jwt = {
      mode = "0444";
      owner = "prysmbeacon";
      group = "prysmbeacon";
      path = "/var/lib/ethereum/jwt.hex";
      restartUnits = [ "prysmbeacon.service" "prysmvalidator.service" ];
    };
    walletPassword = {
      restartUnits = [ "prysmvalidator.service" ];
      owner = "prysmvalidator";
      group = "prysmvalidator";
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
      package = pkgs.master.go-ethereum.geth;
    };
  };

  ##### BEACON ####

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
        "${prysm}/bin/beacon-chain --datadir=${beaconChainDir} --execution-endpoint=http://localhost:8551 --p2p-max-peers=100 --log-format=journald --accept-terms-of-use --block-batch-limit 256 --suggested-fee-recipient=0xFB18b8F2bBE88c4C29ca5a12ee404DB4d640fe4E --jwt-secret=${config.sops.secrets.jwt.path}";
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
        "${prysm}/bin/validator --datadir=${validatorDir} --wallet-dir=${validatorDir}/wallet --wallet-password-file=${config.sops.secrets.walletPassword.path} --accept-terms-of-use --suggested-fee-recipient=0xFB18b8F2bBE88c4C29ca5a12ee404DB4d640fe4E";
      SupplementaryGroups = [ config.users.groups.keys.name ];
    };
  };
}
