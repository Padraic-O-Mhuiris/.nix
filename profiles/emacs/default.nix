{ config, lib, pkgs, inputs, ... }:

let inherit (inputs) nix-doom-emacs;

in {
  environment.systemPackages = with pkgs; [ fd ripgrep parinfer-rust ];

  home-manager.users.padraic = {
    imports = [ nix-doom-emacs.hmModule ];
    programs.doom-emacs = {
      enable = true;
      doomPrivateDir = ./doom.d;
    };
  };

  fonts.fonts = with pkgs; [ emacs-all-the-icons-fonts ];
}
