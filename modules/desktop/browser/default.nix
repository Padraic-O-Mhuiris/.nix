{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let cfg = config.modules.desktop.browser;
in {
  options.modules.desktop.browser = {
    default = mkOpt (with types; nullOr str) null;
  };

  config = mkIf (cfg.default != null) { env.BROWSER = cfg.default; };
}
