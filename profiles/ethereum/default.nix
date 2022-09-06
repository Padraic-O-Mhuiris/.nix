{ config, lib, pkgs, ... }:

{
  imports = [ ./geth.nix ./beacon-chain.nix ./validator.nix ];

  services.ntp.enable = true;
}
