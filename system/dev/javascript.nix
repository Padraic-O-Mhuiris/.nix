{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs.unstable; [
    nodejs-14_x
    nodePackages.yalc
    nodePackages.typescript-language-server
    nodePackages.javascript-typescript-langserver
    nodePackages.jsonlint
    nodePackages.pnpm
    nodePackages.yarn
  ];
}
