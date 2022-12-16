{
  description = "Padraic-O-Mhuiris - NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    hardware.url = "github:NixOS/nixos-hardware";
    emacs.url = "github:nix-community/emacs-overlay";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fup.url = "github:gytis-ivaskevicius/flake-utils-plus";
    deploy-rs.url = "github:serokell/deploy-rs";
    fenix.url = "github:nix-community/fenix";
    sops.url = "github:Mic92/sops-nix";
    devshell.url = "github:numtide/devshell";
    foundry.url = "github:shazow/foundry.nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-master, home-manager
    , sops, hardware, emacs, fup, deploy-rs, fenix, devshell, foundry, ...
    }@inputs:
    let
      inherit (fup.lib) mkFlake;

      lib = nixpkgs.lib.extend (import ./lib);

    in mkFlake {
      inherit self inputs lib;

      channels.unstable.input = nixpkgs-unstable;
      channels.master.input = nixpkgs-master;
      channels.nixpkgs.overlaysBuilder = channels:
        [ (final: prev: { inherit (channels) unstable master; }) ];

      channelsConfig = {
        allowBroken = true;
        allowUnfree = true;
      };

      hostDefaults.system = "x86_64-linux";

      hostDefaults.modules =
        [ home-manager.nixosModules.home-manager sops.nixosModules.sops ];

      sharedOverlays = [
        (self: super: {
          nix-direnv = super.nix-direnv.override { enableFlakes = true; };
        })
        devshell.overlay
        emacs.overlay
        fenix.overlays.default
        foundry.overlay
      ];

      hosts = lib.mkHosts ./hosts { inherit inputs; };

      outputsBuilder = channels:
        let pkgs = channels.nixpkgs;
        in {
          devShells = {
            default = pkgs.devshell.mkShell {
              name = "secrets";
              packages = with pkgs; [ sops age ssh-to-age ];
              env = [
                {
                  name = "SOPS_AGE_KEY";
                  eval =
                    ''$(ssh-to-age -private-key -i "$HOME/.ssh/id_ed25519")'';
                }
                {
                  name = "EDITOR";
                  value = "vim";
                }
              ];
            };
            nixos = pkgs.devshell.mkShell {
              name = "secrets";
              packages = with pkgs; [ sops age ssh-to-age ];
              env = [
                {
                  name = "SOPS_AGE_KEY";
                  eval = "$(pass show machines/user/nixos/age)";
                }
                {
                  name = "EDITOR";
                  value = "vim";
                }
              ];
            };
          };
        };

      # = let
      #   ls = builtins.readDir ./shells;
      #   files = builtins.filter (name: ls.${name} == "regular")
      #     (builtins.attrNames ls);
      #   shellNames = builtins.map
      #     (filename: builtins.head (builtins.split "\\." filename)) files;
      #   nameToValue = name:
      #     import (./shells + "/${name}.nix") { inherit pkgs inputs; };
      # in builtins.listToAttrs (builtins.map (name: {
      #   inherit name;
      #   value = nameToValue name;
      # }) shellNames);
      #};

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
