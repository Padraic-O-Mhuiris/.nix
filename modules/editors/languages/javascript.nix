{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.languages.javascript;
in {
  options.modules.editors.languages.javascript = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      yarn
      npm
      nodejs
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.javascript-typescript-langserver
      nodePackages.jsonlint
    ];
  };
}
