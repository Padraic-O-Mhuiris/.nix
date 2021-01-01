{
  description = "Padraic-O-Mhuiris - NixOS";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    }; # for my regular nixpkgs
    nixpkgs-unstable = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    nixpkgs-master = { url = "github:nixos/nixpkgs/master"; }; # for nixFlakes

    nix = { url = "github:nixos/nix/master"; };

    hardware = { url = "github:nixos/nixos-hardware"; };

    nix-doom-emacs = { url = "github:vlaci/nix-doom-emacs"; };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dapptools = {
      type = "git";
      url = "https://github.com/dapphub/dapptools";
      flake = false;
    };

  };

  outputs = inputs:
    let
      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f:
        builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
      mkSystem = pkgs_: hostname:
        pkgs_.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ (./. + "/hosts/${hostname}/configuration.nix") ];
          specialArgs = { inherit inputs; };
        };
    in rec {
      nixosConfigurations = { Hydrogen = mkSystem inputs.nixpkgs "Hydrogen"; };
      toplevels =
        genAttrs (builtins.attrNames inputs.self.outputs.nixosConfigurations)
        (attr: nixosConfigurations.${attr}.config.system.build.toplevel);
    };
}
