{
  description = "Padraic-O-Mhuiris - NixOS";

  inputs = {

    nix.url = "github:NixOS/nix/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    hardware.url = "github:NixOS/nixos-hardware";

    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    rust-overlay.url = "github:oxalica/rust-overlay";
    nix-doom-emacs = { url = "github:vlaci/nix-doom-emacs"; };
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    hm = { url = "github:nix-community/home-manager"; };
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = inputs@{ self, nixpkgs, utils, hm, ... }:
    let
      inherit (utils.lib) mkFlake exportModules;
      pkgs = self.pkgs.x86_64-linux.nixpkgs;

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit pkgs inputs;
          lib = self;
        };
      });

    in mkFlake {
      inherit self inputs;
      lib = lib.my;

      supportedSystems = [ "x86_64-linux" ];

      channelsConfig = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };

      overlay = import ./overlays;
      sharedOverlays = [ self.overlay ];

      hostDefaults.modules = [ hm.nixosModules.home-manager ];

      hosts.Hydrogen.modules = [ ./hosts/Hydrogen ];
      hosts.Oxygen.modules = [ ./hosts/Oxygen ];
    };

  # outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, agenix, dapptools, ... }:
  #   let
  #     inherit (lib.my) mapModules mapModulesRec mapHosts;

  #     system = "x86_64-linux";

  #     mkPkgs = pkgs: extraOverlays:
  #       import pkgs {
  #         inherit system;
  #         config.allowUnfree = true; # forgive me Stallman senpai
  #         config.allowBroken = true;
  #         overlays = extraOverlays ++ (lib.attrValues self.overlays);
  #       };
  #     pkgs = mkPkgs nixpkgs [ self.overlay ];
  #     pkgs' = mkPkgs nixpkgs-unstable [ ];

  #     lib = nixpkgs.lib.extend (self: super: {
  #       my = import ./lib {
  #         inherit pkgs inputs;
  #         lib = self;
  #       };
  #     });
  #   in {
  #     lib = lib.my;

  #     overlay = final: prev: {
  #       unstable = pkgs';
  #       my = self.packages."${system}";
  #     };

  #     overlays = mapModules ./overlays import;

  #     packages."${system}" = mapModules ./packages (p: pkgs.callPackage p { });

  #     devShell."${system}" = import ./shell.nix { inherit pkgs; };

  #     nixosModules = {
  #       dotfiles = import ./.;
  #     } // mapModulesRec ./modules import;

  #     nixosConfigurations = mapHosts ./hosts { };
  #   };
}
