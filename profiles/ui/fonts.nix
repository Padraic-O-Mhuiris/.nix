{ config, lib, pkgs, ... }:

with lib;
with lib.os;

{
  options.os.ui.fonts = {
    monospace = mkOpt types.str "Iosevka";
    sansSerif = mkOpt types.str "Roboto";
    serif = mkOpt types.str "Roboto";
  };
  config = {
    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
        corefonts
        iosevka
        ubuntu_font_family
        dejavu_fonts
        liberation_ttf
        roboto
        fira-code
        jetbrains-mono
        siji
        font-awesome
        cascadia-code
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [ config.os.ui.fonts.monospace ];
          sansSerif = [ config.os.ui.fonts.sansSerif ];
          serif = [ config.os.ui.fonts.serif ];
        };
      };
    };
  };
}
