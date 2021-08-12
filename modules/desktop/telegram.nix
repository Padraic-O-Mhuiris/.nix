{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.telegram;
in {
  options.modules.desktop.telegram = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ tdesktop ]; };
}
