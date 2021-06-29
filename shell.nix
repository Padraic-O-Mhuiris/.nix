{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  sopsPGPKeys = [ 
    "./keys/padraic.asc"
  ];
  nativeBuildInputs = [
    (pkgs.callPackage <sops-nix> {}).sops-pgp-hook
  ];
}
