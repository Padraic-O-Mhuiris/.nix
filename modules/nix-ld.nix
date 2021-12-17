{ config, inputs, lib, pkgs, stdenv, ... }:

let inherit (inputs) nix-ld;
in {
  imports = [ nix-ld.nixosModules.nix-ld ];

  environment.variables = {
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [ stdenv.cc.cc ];
    NIX_LD = lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";
  };
}
