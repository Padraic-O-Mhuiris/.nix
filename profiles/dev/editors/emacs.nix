{ config, lib, pkgs, ... }: {
  services.emacs = {
    enable = true;
    package = pkgs.emacsNativeComp;
  };

  fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];
  user.packages = with pkgs; [
    binutils
    (ripgrep.override { withPCRE2 = true; })
    gnutls
    shellcheck
    scrot
    fd
    imagemagick
    zstd
    (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
    languagetool
    editorconfig-core-c
    sqlite
    postgresql
    graphviz
    pandoc
    wordnet
    nixfmt
    anystyle-cli
    proselint
    texlive.combined.scheme-full
  ];
}
