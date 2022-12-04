{ config, lib, pkgs, ... }:

{
  services.emacs = {
    enable = true;
    package = pkgs.emacsUnstable;
  };

  fonts.fonts = with pkgs; [ pkgs.emacs-all-the-icons-fonts ];

  users.users.padraic.packages = with pkgs; [
    (ripgrep.override { withPCRE2 = true; })
    editorconfig-core-c
    sqlite
    nixfmt
    proselint
  ];
}
