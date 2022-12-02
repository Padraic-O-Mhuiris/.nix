{ config, lib, pkgs, ... }: {
  environment.systemPackages = [
    pkgs.solc
    (import ../../packages/foundry.nix {
      inherit pkgs;
      inherit lib;
    })
  ];
}
