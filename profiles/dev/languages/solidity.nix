{
  config,
  lib,
  pkgs,
  ...
}: {
  user.packages = [
    pkgs.solc
    (import ../../../packages/foundry.nix {
      inherit pkgs;
      inherit lib;
    })
  ];
}
