{ config, inputs, lib, pkgs, ... }:

# let inherit (inputs) nix-ld;
# in
{
  # imports = [ nix-ld.nixosModules.nix-ld ];

  # environment.variables = {
  #   NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.stdenv.cc.cc ];
  #   NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
  # };
}
