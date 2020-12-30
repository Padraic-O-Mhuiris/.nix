{
  description = "Padraic-O-Mhuiris - NixOS";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-20.09"; }; # for my regular nixpkgs
    nixpkgs-unstable = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    nixpkgs-master = { url = "github:nixos/nixpkgs/master"; }; # for nixFlakes

    nix.url = "github:nixos/nix/master";
    nix-hardware = { url = "github:nixos/nixos-hardware"; };

    home-manager ={
      url =  "github:nix-community/home-manager";
      #inputs.nixpkgs.follows = "/release-20.09";
    };
  };

  outputs = inputs:
    let 
      mkSystem = pkgs_: hostname:
        pkgs_.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [(./. + "/hosts/${hostname}/configuration.nix")];
          specialArgs = { inherit inputs; };
        };
  in {
    nixosConfigurations = {
      Hydrogen = mkSystem inputs.nixpkgs "Hydrogen";
    };
  };
}
