{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.languages.rust;
in {
  options.modules.editors.languages.rust = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.rustup ];

    env.RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
    env.CARGO_HOME = "$XDG_DATA_HOME/cargo";
    env.PATH = [ "$CARGO_HOME/bin" ];

  };
}
