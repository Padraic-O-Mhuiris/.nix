{ config, lib, pkgs, ... }:

{
  user.packages = with pkgs; [ editorconfig-core-c neovim ];

  environment.shellAliases = {
    vim = "nvim";
    v = "nvim";
  };
}
