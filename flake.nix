{
  description = "Padraic-O-Mhuiris - NixOS";

  inputs = {

    master = {
      url = "github:NixOS/nixpkgs/master";
    };

    nixpkgs-unstable.url = "nixpkgs/master";    # for packages on the edge

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
    sops-nix.url = "github:Mic92/sops-nix";

    #dapptools = { url = "github:dapphub/dapptools"; };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, sops-nix, ... }:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      utils = import ./utils.nix {
        inherit lib system pkgs inputs self;
      };
      
      system = "x86_64-linux";

      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true;  # forgive me Stallman senpai
        overlays = extraOverlays ++ (lib.attrValues self.overlays);
      };
      pkgs  = mkPkgs nixpkgs [ self.overlay ];
      pkgs' = mkPkgs nixpkgs-unstable [];

      lib = nixpkgs.lib.extend
        (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });
    in {
      lib = lib.my;

      overlay =
        final: prev: {
          unstable = pkgs';
          my = self.packages."${system}";
        };

      overlays =
        mapModules ./overlays import;

      packages."${system}" =
        mapModules ./packages (p: pkgs.callPackage p {});

      nixosModules =
        { dotfiles = import ./.; } // mapModulesRec ./modules import;

      nixosConfigurations =
        mapHosts ./hosts {};

      # nixosConfigurations = {
      #   Hydrogen = mkSystem nixpkgs "Hydrogen" [
      #     sops-nix.nixosModules.sops
      #   ]; };

      devShell.${system} = let
      in pkgs.mkShell {
        shellhook = "zsh";
      };
    };
}
