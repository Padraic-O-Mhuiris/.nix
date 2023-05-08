{
  description = "Padraic-O-Mhuiris - NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
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
    foundry.url = "github:shazow/foundry.nix/monthly";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    ethereum = {
      url = "github:nix-community/ethereum.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, nixpkgs-master, nixpkgs-stable, home-manager, sops
    , hardware, emacs, fup, deploy-rs, fenix, foundry, ethereum, nur, ...
    }@inputs:
    let
      inherit (fup.lib) mkFlake;

      lib = nixpkgs.lib.extend (import ./lib);

    in mkFlake {
      inherit self inputs lib;

      channels.master.input = nixpkgs-master;
      channels.stable.input = nixpkgs-stable;
      channels.nixpkgs.overlaysBuilder = channels: [
        (final: prev: { inherit (channels) master; })
        (final: prev: { inherit (channels) stable; })
      ];

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
        (self: super: {
          fcitx-engines = self.fcitx5;
        }) # https://discourse.nixos.org/t/error-when-upgrading-nixos-related-to-fcitx-engines/26940/8
        emacs.overlay
        fenix.overlays.default
        foundry.overlay
        nur.overlay
      ];

      hosts = lib.mkHosts ./hosts { inherit inputs; };

      deploy = {
        autoRollback = true;
        remoteBuild = true;
        fastConnection = false;
        nodes = {
          Nitrogen = {
            hostname = "nitrogen.tail69d72.ts.net";
            user = "root";
            sshUser = "root";
            profiles = {
              system.path = deploy-rs.lib.x86_64-linux.activate.nixos
                self.nixosConfigurations.Nitrogen;
            };
          };
        };
      };

      # outputsBuilder = channels:
      #   let pkgs = channels.nixpkgs;
      #   in {
      #     devShells = {
      #       default = pkgs.devshell.mkShell {
      #         name = "secrets";
      #         packages = with pkgs; [ sops age ssh-to-age ];
      #         env = [
      #           {
      #             name = "SOPS_AGE_KEY";
      #             eval =
      #               ''$(ssh-to-age -private-key -i "$HOME/.ssh/id_ed25519")'';
      #           }
      #           {
      #             name = "EDITOR";
      #             value = "vim";
      #           }
      #         ];
      #       };
      #       nixos = pkgs.devshell.mkShell {
      #         name = "secrets";
      #         packages = with pkgs; [ sops age ssh-to-age ];
      #         env = [
      #           {
      #             name = "SOPS_AGE_KEY";
      #             eval = "$(pass show machines/user/nixos/age)";
      #           }
      #           {
      #             name = "EDITOR";
      #             value = "vim";
      #           }
      #         ];
      #       };
      #     };
      #   };

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
