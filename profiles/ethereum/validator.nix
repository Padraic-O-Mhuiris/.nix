{ config, lib, pkgs, ... }:

let
  validatorDir = "/var/lib/prysm/validator";
  validatorPkg = (import ../../packages/prysmvalidator.nix { inherit pkgs; });
in {
  users.extraUsers = {
    prysmvalidator = {
      isSystemUser = true;
      shell = null;
      hashedPassword = "*";
      home = validatorDir;
      group = "prysmvalidator";
    };
  };
  users.groups."prysmvalidator" = { };

  systemd.tmpfiles.rules =
    [ "d '${validatorDir}' 0700 prysmvalidator prysmvalidator - -" ];

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
        "${validatorPkg}/bin/prysmvalidator --datadir=${validatorDir} --wallet-dir=${validatorDir}/wallet --wallet-password-file=${config.age.secrets.validatorPassword.path} --accept-terms-of-use --suggested-fee-recipient=0xFB18b8F2bBE88c4C29ca5a12ee404DB4d640fe4E";
    };
  };
}
