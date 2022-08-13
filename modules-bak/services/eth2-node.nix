{ config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.services.eth2-node;
  beaconChainDir = "/var/lib/prysm/beacon";
  validatorDir = "/var/lib/prysm/validator";
in {
  options.modules.services.eth2-node = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable ngrok service";
    };

    passwordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to validator password file";
    };

  };

  config = mkIf cfg.enable {

    services.ntp.enable = true;

    user.packages = with pkgs; [ my.prysmbeacon my.prysmvalidator ];

    users.extraUsers = {
      prysmbeacon = {
        isSystemUser = true;
        shell = null;
        hashedPassword = "*";
        home = beaconChainDir;
        group = "prysmbeacon";
      };
      prysmvalidator = {
        isSystemUser = true;
        shell = null;
        hashedPassword = "*";
        home = validatorDir;
        group = "prysmvalidator";
      };
    };
    users.groups."prysmbeacon" = { };
    users.groups."prysmvalidator" = { };

    systemd.tmpfiles.rules = [
      "d '${beaconChainDir}' 0700 prysmbeacon prysmbeacon - -"
      "d '${validatorDir}' 0700 prysmvalidator prysmvalidator - -"
    ];

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
          "${pkgs.my.prysmbeacon}/bin/prysmbeacon --datadir=${beaconChainDir} --http-web3provider=https://mainnet.infura.io/v3/08ec46105b6d41a3ab9b4adc779d758b --fallback-web3provider=https://eth-mainnet.alchemyapi.io/v2/ryLKf8USqTmpqvcWV89h8bqB457Md-Fw --p2p-max-peers=100 --log-format=journald --accept-terms-of-use --block-batch-limit 256";
      };
    };

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
          "${pkgs.my.prysmvalidator}/bin/prysmvalidator --datadir=${validatorDir} --wallet-dir=${validatorDir}/wallet --wallet-password-file=${cfg.passwordFile} --accept-terms-of-use";
      };
    };
  };
}
