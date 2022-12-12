{ config, lib, pkgs, ... }:

{

  os.user.packages = with pkgs.unstable; [
    nodejs
    nodePackages.yalc
    nodePackages.typescript-language-server
    nodePackages.javascript-typescript-langserver
    nodePackages.jsonlint
    nodePackages.yarn
  ];
}
