{ config, lib, pkgs, ... }:

{
  user.packages = with pkgs; [ editorconfig-core-c unstable.neovim ];
}
