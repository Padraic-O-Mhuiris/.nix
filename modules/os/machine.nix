{ modulesPath, config, lib, pkgs, ... }:

with lib;
with lib.os;

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  options.os.machine = {
    cores = mkOpt types.int 4;
    gpu = mkOpt (type.enum [ "integrated" "nvidia" ]) "integrated";
  };
}
