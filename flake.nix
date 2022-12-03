{
  description = "Padraic-O-Mhuiris - NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    hardware.url = "github:NixOS/nixos-hardware";
    emacs.url = "github:nix-community/emacs-overlay";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    fenix.url = "github:nix-community/fenix";
  };

  outputs = { self, nixpkgs, nixpkgs-master, home-manager, hardware, emacs
    , agenix, deploy-rs, fenix, ... }@inputs:

    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ ];
      };

      util = import ./lib {
        inherit system pkgs home-manager lib;
        overlays = (pkgs.overlays);
      };
      # packages-overlay = final: prev: {
      #   unstable = import nixpkgs-unstable {
      #     inherit system;
      #     config.allowUnfree = true;
      #     config.allowBroken = true;
      #   };
      #   master = import nixpkgs-master {
      #     inherit system;
      #     config.allowUnfree = true;
      #     config.allowBroken = true;
      #   };
      # };

      # lib = pkgs.lib.extend (final: prev: {
      #   local = (import ./lib {
      #     lib = prev;
      #     inherit pkgs;
      #     nixosConfigurations
      #   });
      # });

    in {
      supportedSystems = [ "x86_64-linux" ];

      # sharedOverlays = [
      #   (self: super: {
      #     nix-direnv = super.nix-direnv.override { enableFlakes = true; };
      #   })
      #   emacs.overlay
      #   packages-overlay
      #   fenix.overlays.default
      # ];

      # hostDefaults.modules = [
      #   home-manager.nixosModules.home-manager
      #   agenix.nixosModule
      #   ./modules/secrets.nix
      # ];

      # hosts = pkgs.lib.mkMerge [
      #   {
      #     Hydrogen.modules = [
      #       ./profiles/personal.nix
      #       ./hosts/Hydrogen
      #       hardware.nixosModules.dell-xps-15-9500
      #     ];
      #   }
      #   (lib.mkHost {
      #     name = "Oxygen";
      #     modules = [ ./hardware/Oxygen ./system/local ./user/padraic ];
      #   })
      #   # Oxygen = {
      #   #   modules = [
      #   #     ./hardware/Oxygen
      #   #     ./system/local
      #   #     ./user/padraic
      #   #     #./profiles/ethereum
      #   #     #./profiles/ngrok.nix
      #   #   ];
      #   #   specialArgs = { lib = lib // { host = (lib.local.host "Oxygen"); }; };
      #   # };
      #   # Nitrogen = { modules = [ ./hosts/Nitrogen ]; };
      # ];

      # deploy = {
      #   autoRollback = true;
      #   tempPath = "/home/padraic/.deploy-rs";
      #   remoteBuild = true;
      #   fastConnection = false;
      #   user = "root";
      #   sshUser = "padraic";
      #   nodes = {
      #     Nitrogen = {
      #       hostname = "ec2-3-250-174-155.eu-west-1.compute.amazonaws.com";
      #       profiles = {
      #         system = {
      #           path = deploy-rs.lib.x86_64-linux.activate.nixos
      #             self.nixosConfigurations.Nitrogen;
      #         };

      #       };
      #     };
      #   };
      # };

      # checks = builtins.mapAttrs
      #   (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      # outputsBuilder = (channels: {
      #   devShell = channels.nixpkgs.mkShell {
      #     name = "nix-deploy-shell";
      #     buildInputs = with channels.nixpkgs; [
      #       nixUnstable
      #       inputs.deploy-rs.defaultPackage.${system}
      #     ];
      #   };

      #});
    };
}
