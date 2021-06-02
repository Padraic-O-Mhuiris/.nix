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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "master";
    };
  };

  outputs = inputs@{ self, nixpkgs, sops-nix, ... }:
    let
      inherit (nixpkgs) lib;
      utils = import ./utils.nix {
        inherit lib system pkgs inputs self;
      };
      
      system = "x86_64-linux";
      pkgs = (utils.pkgImport nixpkgs);
      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f:
        builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
      mkSystem = pkgs_: hostname:
        pkgs_.lib.nixosSystem {
          system = system;
          modules = [
            (./. + "/hosts/${hostname}/configuration.nix")
            sops-nix.nixosModules.sops
          ];
          specialArgs = { inherit inputs; };
        };
    in {
      nixosConfigurations = { Hydrogen = mkSystem nixpkgs "Hydrogen"; };

      devShell.${system} = let
      in pkgs.mkShell {
        sopsPGPKeyDirs = [
          "./secrets/keys"
        ];
        nativeBuildInputs = [
          (pkgs.callPackage sops-nix { }).sops-pgp-hook
        ];
        buildInputs = [ pkgs.sops ];
        shellhook = "zsh";
      };
    };
}
