{
  description = "Padraic-O-Mhuiris - NixOS";

  inputs = {

    master = {
      url = "github:NixOS/nixpkgs/master";
    };

    unstable = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    nixpkgs = {
      url = "github:NixOS/nixpkgs/release-21.05";
    };

    nix = { url = "github:nixos/nix/master"; };

    hardware = { url = "github:nixos/nixos-hardware"; };

    flake-utils = {
      url = github:numtide/flake-utils;
      inputs.nixpkgs.follows = "master";
    };

    nix-doom-emacs = { url = "github:vlaci/nix-doom-emacs"; };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #dapptools = { url = "github:dapphub/dapptools"; };
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      utils = import ./utils.nix {
        inherit lib system pkgs inputs self;
      };
      
      system = "x86_64-linux";
      pkgs = (utils.pkgImport nixpkgs);
      mkSystem = utils.mkSystem;

    in {
      nixosConfigurations = { Hydrogen = mkSystem nixpkgs "Hydrogen" []; };

      devShell.${system} = let
      in pkgs.mkShell {
        shellhook = "zsh";
      };
    };
}
