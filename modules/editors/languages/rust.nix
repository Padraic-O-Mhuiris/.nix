{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.languages.rust;

in {
  options.modules.editors.languages.rust = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    nixpkgs.overlays = [ inputs.rust-overlay.overlay ];
    user.packages = with pkgs; [ rust-bin.stable.latest.default rust-analyzer ];
  };
}
