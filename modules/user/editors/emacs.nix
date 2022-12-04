{ config, lib, pkgs, ... }:

{
  services.emacs = {
    enable = true;
    package = pkgs.emacsNativeComp;
  };

  fonts.fonts = with pkgs; [ emacs-all-the-icons-fonts ];

  os.user.packages = with pkgs; [
    (ripgrep.override { withPCRE2 = true; })
    editorconfig-core-c
    sqlite
    nixfmt
    proselint
  ];
}
