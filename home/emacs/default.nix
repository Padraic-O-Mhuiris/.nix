{ config, lib, pkgs, inputs, ... }:

let
  inherit (inputs) nix-doom-emacs;
in {
  imports = [ nix-doom-emacs.hmModule ];


  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d; 
  };

  # services.emacs = {
  #   enable = true;
  #   client = { enable = true; };
  #   socketActivation.enable = true;
  # };

  home.file.".emacs.d/init.el".text = ''
    (load "default.el")
  '';
}
