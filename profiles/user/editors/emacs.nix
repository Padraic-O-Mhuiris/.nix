{ config, lib, pkgs, ... }:

{
  services.emacs = {
    enable = true;
    package = pkgs.emacsUnstable;
  };

  fonts.fonts = with pkgs; [ emacs-all-the-icons-fonts ];

  os.user.packages = with pkgs; [
    binutils
    git
    (ripgrep.override { withPCRE2 = true; })
    gnutls
    fd
    imagemagick
    zstd
    (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
    editorconfig-core-c
    sqlite
    nixfmt
    proselint
    nodePackages_latest.markdownlint-cli
    lua-language-server
    pandoc
    emacsPackages.pdf-tools
    beancount
    beancount-language-server
    ispell
    jupyter
  ];
}
