{ lib
, self
, inputs
, system
, pkgs
, ...
}:

{
  pkgImport = pkgs: import pkgs {
    inherit system;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ ];
    };
  };
  
  mkSystem = pkgs_: hostname: extra_modules:
    pkgs_.lib.nixosSystem {
      system = system;
      modules = [
        (./. + "/hosts/${hostname}/configuration.nix")
      ] ++ extra_modules;
      specialArgs = { inherit inputs; };
    };
}
