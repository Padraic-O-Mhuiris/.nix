{
  description = "Padraic-O-Mhuiris - NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    hardware.url = "github:NixOS/nixos-hardware";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    emacs.url = "github:nix-community/emacs-overlay";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust.url = "github:oxalica/rust-overlay";

    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, utils, home-manager
    , hardware, emacs, rust, agenix, ... }:
    let
      inherit (utils.lib) mkFlake exportModules;
      pkgs = self.pkgs.x86_64-linux.nixpkgs;
      system = "x86_64-linux";

      unstable-overlay = (final: prev: {
        unstable = import nixpkgs-unstable { inherit system; };
      });

    in mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      channelsConfig = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };

      sharedOverlays = [ emacs.overlay rust.overlay unstable-overlay ];

      hostDefaults.modules = [
        home-manager.nixosModules.home-manager
        agenix.nixosModules.age
        ./modules
      ];

      hosts = {
        Hydrogen.modules = [
          ./hosts/Hydrogen
          hardware.nixosModules.dell-xps-15-9500-nvidia
          ./profiles/personal.nix
        ];
        Oxygen.modules = [ ./hosts/Oxygen ];
      };
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
