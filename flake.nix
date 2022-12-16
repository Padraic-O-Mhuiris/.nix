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

      deploy = {
        autoRollback = true;
        remoteBuild = true;
        fastConnection = false;
        nodes = {
          Nitrogen = {
            hostname = "nitrogen.tail69d72.ts.net";
            user = "nixos";
            tempPath = "/home/nixos/.deploy-rs";
            profiles = {
              system = {
                path = deploy-rs.lib.x86_64-linux.activate.nixos
                  self.nixosConfigurations.Nitrogen;
              };

            };
          };
        };
      };

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

      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

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
