{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;

let cfg = config.modules.desktop.tools.libreoffice;
in {
  options.modules.desktop.tools.libreoffice = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ libreoffice ]; };
}
