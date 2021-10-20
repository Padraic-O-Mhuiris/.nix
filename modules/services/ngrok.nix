{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.ngrok;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.ngrok = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    imports = [ ./ngrok ]; # custom service file

    user.packages = with pkgs; [ ngrok ];

    services.ngrok = {
      enable = true;
      configFile = config.age.secrets.ngrokConfig.path;
    };
  };
}
