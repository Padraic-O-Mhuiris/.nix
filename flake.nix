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
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = inputs@{ self, nixpkgs, utils, home-manager, hardware, emacs, ... }:
    let
      inherit (utils.lib) mkFlake exportModules;
      pkgs = self.pkgs.x86_64-linux.nixpkgs;

    in mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      channelsConfig = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };

      overlay = import ./overlays;

      sharedOverlays = [ self.overlay emacs.overlay ];

      hostDefaults.modules = [
        home-manager.nixosModules.home-manager
        ./modules/base.nix
        ./modules/user.nix
      ];

      hosts = {
        Hydrogen.modules =
          [ ./hosts/Hydrogen hardware.nixosModules.dell-xps-15-9500-nvidia ];
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
