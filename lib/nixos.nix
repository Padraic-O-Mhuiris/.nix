{ inputs, lib, pkgs, ... }:

with lib;
with lib.my;
let sys = "x86_64-linux";
in {
  mkHost = path:
    attrs@{ system ? sys, ... }:
    otherModules:
    nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        {
          nixpkgs.pkgs = pkgs;
          networking.hostName =
            mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        ../. # /default.nix
        (import path)
      ] ++ otherModules;
    };

  mapHosts = dir:
    attrs@{ system ? system, ... }:
    otherModules:
    mapModules dir (hostPath: mkHost hostPath attrs otherModules);
}
