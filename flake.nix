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
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    fenix.url = "github:nix-community/fenix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-master, home-manager
    , hardware, emacs, fup, agenix, deploy-rs, fenix, ... }@inputs:
    let
      inherit (fup.lib) mkFlake;

      pkgs = nixpkgs;
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

      hostDefaults.modules = [
        home-manager.nixosModules.home-manager
        agenix.nixosModule
        #./modules/os.nix
        #./modules/secrets.nix
      ];

      sharedOverlays = [
        (self: super: {
          nix-direnv = super.nix-direnv.override { enableFlakes = true; };
        })
        emacs.overlay
        fenix.overlays.default
      ];

      # builds fup host attrset while inheriting custom lib functions
      hosts = lib.mkHosts ./hosts;

      #.modules = [ ];
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
