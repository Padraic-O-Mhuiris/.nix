{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.languages.javascript;
in {
  options.modules.editors.languages.javascript = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs.unstable; [
      nodejs-14_x
      nodePackages.yalc
      nodePackages.typescript-language-server
      nodePackages.javascript-typescript-langserver
      nodePackages.jsonlint
      nodePackages.pnpm
      nodePackages.yarn
    ];

    modules.shell.zsh.rcInit = ''
      export PATH="$(yarn global bin):$PATH"
    '';
  };
}
