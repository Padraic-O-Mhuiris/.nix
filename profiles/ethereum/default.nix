{ config, lib, pkgs, ... }:

let ethereumDir = "/var/lib/ethereum";
in {
  imports = [ ./geth.nix ./beacon-chain.nix ./validator.nix ];

  users.extraUsers = {
    ethereum = {
      isSystemUser = true;
      shell = null;
      hashedPassword = "*";
      home = ethereumDir;
      group = "ethereum";
    };
  };
  users.groups."ethereum" = { };
  systemd.tmpfiles.rules =
    [ "d '/var/lib/ethereum' 0700 ethereum ethereum - -" ];

  services.ntp.enable = true;
}
