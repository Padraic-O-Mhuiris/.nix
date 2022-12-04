{ config, lib, pkgs, ... }:

with lib;
with lib.os;

{
  options.os.machine = {
    kernel = mkOpt types.attrs
      pkgs.linuxPackages_6_0; # TODO fix to correct submodule type if possible
    cores = mkOpt types.int 4;
    gpu = mkOpt (type.enum [ "integrated" "nvidia" ]) "integrated";
  };
}
