{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.services.geth;
  configDir = config.dotfiles.configDir;
in {
  options.modules.services.geth = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ go-ethereum ]; };
}
