{
  description = "Padraic-O-Mhuiris - NixOS";

  inputs = {
    master = { url = "github:NixOS/nixpkgs/master"; };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix = { url = "github:NixOS/nix/master"; };
    hardware = { url = "github:NixOS/nixos-hardware"; };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "master";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";

    nix-doom-emacs = { url = "github:vlaci/nix-doom-emacs"; };
    emacs-overlay.url = "github:nix-community/emacs-overlay";

    home-manager = { url = "github:nix-community/home-manager"; };
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs-unstable";

    dapptools = {
      url = "github:dapphub/dapptools";
      flake = false;
    };

    base16.url = "github:SenchoPens/base16.nix";
    base16.inputs.nixpkgs.follows = "nixpkgs";

    base16-schemes = {
      url = "github:base16-project/base16-schemes";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, agenix, dapptools, ... }:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      system = "x86_64-linux";

      mkPkgs = pkgs: extraOverlays:
        import pkgs {
          inherit system;
          config.allowUnfree = true; # forgive me Stallman senpai
          config.allowBroken = true;
          overlays = extraOverlays ++ (lib.attrValues self.overlays);
        };
      pkgs = mkPkgs nixpkgs [ self.overlay ];
      pkgs' = mkPkgs nixpkgs-unstable [ ];

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit pkgs inputs;
          lib = self;
        };
      });
    in {
      lib = lib.my;

      overlay = final: prev: {
        unstable = pkgs';
        my = self.packages."${system}";
      };

      overlays = mapModules ./overlays import;

      packages."${system}" = mapModules ./packages (p: pkgs.callPackage p { });

      devShell."${system}" = import ./shell.nix { inherit pkgs; };

      nixosModules = {
        dotfiles = import ./.;
      } // mapModulesRec ./modules import;

      nixosConfigurations = mapHosts ./hosts { };
    };
}
