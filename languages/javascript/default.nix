{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    yarn
    nodejs
    nodePackages.typescript-language-server
    nodePackages.typescript
    nodePackages.node2nix
    nodePackages.javascript-typescript-langserver
    nodePackages.jsonlint
  ];
}
