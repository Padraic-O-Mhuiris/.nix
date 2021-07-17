{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.languages.python;
in {
  options.modules.editors.languages.python = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs.python38Packages;
      with pkgs.python27Packages; [
        python
        pip
        setuptools
        virtualenv
      ];
  };
}
