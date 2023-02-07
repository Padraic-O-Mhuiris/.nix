{ config, lib, pkgs, inputs, ... }:

{
  services.emacs = {
    enable = true;
    package = pkgs.emacsPgtk;
  };

  fonts.fonts = with pkgs; [ emacs-all-the-icons-fonts ];

  os.user.packages = with pkgs; [
    (ripgrep.override { withPCRE2 = true; })
    editorconfig-core-c
    sqlite
    nixfmt
    proselint
    nodePackages_latest.markdownlint-cli
    pandoc
    emacsPackages.pdf-tools
    beancount
    beancount-language-server
    ispell
    jupyter
  ];
}
