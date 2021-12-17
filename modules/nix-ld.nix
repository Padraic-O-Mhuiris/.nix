{ config, inputs, lib, pkgs, ... }:

let inherit (inputs) nix-ld;
in { imports = [ nix-ld.nixosModules.nix-ld ]; }
