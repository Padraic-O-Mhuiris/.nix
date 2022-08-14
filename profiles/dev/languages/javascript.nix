{ config, lib, pkgs, ... }:

{
  user.packages = with pkgs; [
    nodejs-14_x
    nodePackages.yalc
    nodePackages.typescript-language-server
    nodePackages.javascript-typescript-langserver
    nodePackages.jsonlint
    nodePackages.pnpm
    nodePackages.yarn
  ];
}
