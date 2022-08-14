{ config, lib, pkgs, ... }:

{
  imports = [ ./emacs.nix ./vim.nix ];

  env.EDITOR = "emacs";
}
