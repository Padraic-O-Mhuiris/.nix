{ pkgs, ... }:

let
  emacs = pkgs.callPackage (builtins.fetchTarball {
    url = "https://github.com/vlaci/nix-doom-emacs/archive/master.tar.gz";
  }) { doomPrivateDir = ./doom.d; };
in {
  programs.emacs.package = emacs;
  programs.emacs.enable = true;

  services.emacs = {
    enable = true;
    client = { enable = true; };
    socketActivation.enable = true;
  };

  home.file.".emacs.d/init.el".text = ''
    (load "default.el")
  '';
}
