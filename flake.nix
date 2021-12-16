{
  description = "Padraic-O-Mhuiris - NixOS";

  inputs = {

    master = { url = "github:NixOS/nixpkgs/master"; };

    nixpkgs.url = "nixpkgs/21.11"; # for packages on the edge
    nixpkgs-2105.url = "nixpkgs/21.05";

    nixpkgs-unstable.url =
      "nixpkgs/nixpkgs-unstable"; # for packages on the edge

    nix = { url = "github:nixos/nix/master"; };

    hardware = { url = "github:nixos/nixos-hardware"; };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "master";
    };

    nix-doom-emacs = { url = "github:vlaci/nix-doom-emacs"; };
    emacs-overlay.url = "github:nix-community/emacs-overlay";

    home-manager = { url = "github:nix-community/home-manager"; };
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    dapptools = {
      url = "github:dapphub/dapptools";
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
