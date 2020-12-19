{ config, lib, pkgs, ... }:

{
  programs.emacs.enable = true;
  programs.emacs.package = pkgs.callPackage (builtins.fetchTarball {
    url = "https://github.com/vlaci/nix-doom-emacs/archive/master.tar.gz";
  }) { doomPrivateDir = ./doom.d; };

  # services.emacs = {
  #   enable = true;
  #   client = { enable = true; };
  #   socketActivation.enable = true;
  # };

  home.file.".emacs.d/init.el".text = ''
    (load "default.el")
  '';
}
