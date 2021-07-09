{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;

let cfg = config.modules.hardware.fs;
in {
  options.modules.hardware.fs = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { programs.udevil.enable = true; };
}
