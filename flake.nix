{
  description = "Padraic-O-Mhuiris - NixOS";

  inputs = {

    master = { url = "github:NixOS/nixpkgs/master"; };

    nixpkgs.url = "nixpkgs/21.05"; # for packages on the edge

    nix = { url = "github:nixos/nix/master"; };

    hardware = { url = "github:nixos/nixos-hardware"; };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "master";
    };

    nix-doom-emacs = { url = "github:vlaci/nix-doom-emacs"; };
    emacs-overlay.url = "github:nix-community/emacs-overlay";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";

    dapptools = { url = "github:dapphub/dapptools"; };
  };

  outputs = inputs@{ self, nixpkgs, sops-nix, dapptools, ... }:
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      system = "x86_64-linux";

      mkPkgs = pkgs: extraOverlays:
        import pkgs {
          inherit system;
          config.allowUnfree = true; # forgive me Stallman senpai
          config.allowBroken = true;
          overlays = extraOverlays;
        };
      pkgs = mkPkgs nixpkgs [ self.overlay ];

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit pkgs inputs;
          lib = self;
        };
      });
    in {
      lib = lib.my;

      nixosModules = {
        dotfiles = import ./.;
      } // mapModulesRec ./modules import;

      nixosConfigurations = mapHosts ./hosts { };

      devShell.${system} = let in pkgs.mkShell { shellhook = "zsh"; };
    };
}
