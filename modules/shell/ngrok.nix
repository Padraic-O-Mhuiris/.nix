{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.ngrok;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.ngrok = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ ngrok ];

  };
}
