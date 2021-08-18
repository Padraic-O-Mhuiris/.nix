{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.languages.haskell;
in {
  options.modules.editors.languages.haskell = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      ghc
      cabal2nix
      cabal-install
      stack
      haskell-language-server
      stack
      hlint
      haskellPackages.brittany
    ];
  };
}
