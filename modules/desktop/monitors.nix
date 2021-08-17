{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.monitors;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.monitors = {
    enable = mkBoolOpt false;
    primary = mkOpt (with types; str) "HDMI-0";
    rate = mkOpt (with types; int) 60;
    mode = mkOpt (with types; str) "1920x1080";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ autorandr ];

    home.configFile."autorandr".source = "${configDir}/autorandr";

    services.autorandr = {
      enable = true;
      defaultTarget = "Samsung_5120x1440";
    };
  };
}
