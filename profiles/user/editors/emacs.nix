{ config, lib, pkgs, inputs, ... }:

{
  services.emacs = {
    enable = true;
    package = pkgs.emacsUnstable;
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
    fava
    beancount
    beancount-language-server
  ];
}
