{ config, lib, pkgs, ... }:

with lib;
with lib.os;

{
  options.os.machine = {
    cores = mkOpt types.int 4;
    gpu = mkOpt (type.enum [ "integrated" "nvidia" ]) "integrated";
  };
}
