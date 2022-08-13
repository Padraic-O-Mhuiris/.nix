{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.matrix;
in {
  options.modules.desktop.matrix = { enable = mkBoolOpt false; };
  config = mkIf cfg.enable { user.packages = with pkgs; [ element-desktop ]; };
}
