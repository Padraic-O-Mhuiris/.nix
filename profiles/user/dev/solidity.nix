{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs; [
    solc
    (import ../../../packages/foundry.nix {
      inherit pkgs;
      inherit lib;
    })
  ];
}
