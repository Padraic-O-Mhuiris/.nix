{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.languages.python;
in {
  options.modules.editors.languages.python = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      python39Full
      python-language-server
      nodePackages.pyright
      black
      python39Packages.nose
      python39Packages.isort
      python39Packages.pyflakes
      poetry
    ];
  };
}
