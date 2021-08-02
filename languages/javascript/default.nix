{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    yarn
    nodejs-12_x
    nodePackages.typescript-language-server
    nodePackages.typescript
    nodePackages.node2nix
    nodePackages.javascript-typescript-langserver
    nodePackages.jsonlint
    nodePackages.prettier
    nodePackages.eslint
  ];
}
