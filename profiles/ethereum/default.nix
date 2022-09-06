{ config, lib, pkgs, ... }:

let ethereumDir = "/var/lib/ethereum";
in {
  imports = [ ./geth.nix ./beacon-chain.nix ./validator.nix ];

  services.ntp.enable = true;
}
