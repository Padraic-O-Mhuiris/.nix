{ config, lib, pkgs, ... }:

{

  os.user.packages = with pkgs.unstable; [
    nodejs-14_x
    nodePackages.yalc
    nodePackages.typescript-language-server
    nodePackages.javascript-typescript-langserver
    nodePackages.jsonlint
    nodePackages.yarn
  ];
}
