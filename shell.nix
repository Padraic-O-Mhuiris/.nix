
  # shell.nix
with import <nixpkgs> {};
mkShell {
  # imports all files ending in .asc/.gpg and sets $SOPS_PGP_FP.
  # sopsPGPKeyDirs = [ 
  #   "./keys"
  # ];
  # Also single files can be imported.
  sopsPGPKeys = [ 
    "./keys/padraic.asc"
  ];
  nativeBuildInputs = [
    (pkgs.callPackage <sops-nix> {}).sops-pgp-hook
  ];
}
