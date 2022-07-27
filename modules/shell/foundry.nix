{ config, options, lib, pkgs, inputs, ... }:

with lib;
with lib.my;

let cfg = config.modules.shell.foundry;

in {
  options.modules.shell.foundry = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ my.foundry ]; };
}
