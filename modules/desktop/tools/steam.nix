{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;

let cfg = config.modules.desktop.tools.steam;

in {
  options.modules.desktop.tools.steam = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { programs.steam.enable = true; };
}
