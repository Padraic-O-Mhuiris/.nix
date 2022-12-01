{ config, lib, pkgs, ... }:

{
  services.emacs = {
    enable = true;
    package = pkgs.emacsNativeComp;
  };

  fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

  environment.systemPackages = with pkgs; [
    (ripgrep.override { withPCRE2 = true; })
    editorconfig-core-c
    sqlite
    nixfmt
    proselint
  ];
}
