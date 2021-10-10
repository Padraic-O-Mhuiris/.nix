{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.secrets;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.secrets = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ ];

  };
}
