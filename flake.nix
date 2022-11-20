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
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nixpkgs-master, utils
    , home-manager, hardware, emacs, agenix, deploy-rs, ... }:

    let
      inherit (utils.lib) mkFlake exportModules;
      pkgs = self.pkgs.x86_64-linux.nixpkgs;
      system = "x86_64-linux";

      packages-overlay = final: prev: {
        unstable = import nixpkgs-unstable { inherit system; };
        master = import nixpkgs-master { inherit system; };
      };
    in mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      channelsConfig = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };

      sharedOverlays = [
        (self: super: {
          nix-direnv = super.nix-direnv.override { enableFlakes = true; };
        })
        emacs.overlay
        packages-overlay
      ];

      hostDefaults.modules =
        [ home-manager.nixosModules.home-manager agenix.nixosModule ./modules ];

      hosts = {
        Hydrogen.modules = [
          ./profiles/personal.nix
          ./hosts/Hydrogen
          hardware.nixosModules.dell-xps-15-9500
        ];
        Oxygen = {
          modules = [
            ./hosts/Oxygen
            ./profiles/personal.nix
            ./modules/ethereum/xgeth.nix
            ./profiles/ethereum
            ./profiles/ngrok.nix
          ];
        };
        Nitrogen = { modules = [ ./hosts/Nitrogen ]; };
      };

      # deploy-rs config
      deploy = {
        nodes = {
          Nitrogen = {
            hostname = "ec2-52-16-215-4.eu-west-1.compute.amazonaws.com";
            fastConnection = false;
            remoteBuild = true;
            user = "root";
            sshUser = "admin";
            profiles = {
              example = {

                path = deploy-rs.lib.x86_64-linux.activate.nixos
                  self.nixosConfigurations.Nitrogen;
              };

            };
          };
        };
      };

      outputsBuilder = (channels: {
        devShell = channels.nixpkgs.mkShell {
          name = "nix-deploy-shell";
          buildInputs = with channels.nixpkgs; [
            nixUnstable
            inputs.deploy-rs.defaultPackage.${system}
          ];
        };
      });
    };
}
