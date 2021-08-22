{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;

let cfg = config.modules.desktop.apps.steam;

in {
  options.modules.desktop.apps.steam = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    user.packages = with pkgs;
      [ (pkgs.steam.override { extraLibraries = pkgs: [ pkgs.pipewire ]; }) ];
  };
}
