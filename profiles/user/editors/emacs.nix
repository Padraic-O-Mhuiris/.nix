{ config, lib, pkgs, inputs, ... }:

{
  services.emacs = {
    enable = true;
    package = with pkgs;
      ((emacsPackagesFor emacsUnstable).emacsWithPackages
        (epkgs: [ epkgs.vterm ]));
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
    pandoc
    emacsPackages.pdf-tools
    beancount
    beancount-language-server
    ispell
    jupyter
  ];

}
