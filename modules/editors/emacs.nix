{ config, lib, pkgs, ... }:

{
  services.emacs = {
    enable = true;
    package = pkgs.emacsNativeComp;
  };

  fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];
}
