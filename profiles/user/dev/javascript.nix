{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs; [
    nodejs
    nodePackages.typescript-language-server
    nodePackages.javascript-typescript-langserver
    nodePackages.jsonlint
    nodePackages.yarn
  ];
}
