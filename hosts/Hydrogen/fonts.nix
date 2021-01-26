{ pkgs, config, lib, ... }: {
  fonts = {
    fonts = with pkgs; [
      iosevka
      nerdfonts
      roboto
      emacs-all-the-icons-fonts
      xorg.fontbhlucidatypewriter100dpi
      xorg.fontbhlucidatypewriter75dpi
      dejavu_fonts
      fira-code
      freefont_ttf
      gyre-fonts # TrueType substitutes for standard PostScript fonts
      liberation_ttf
      xorg.fontbh100dpi
      xorg.fontmiscmisc
      xorg.fontcursormisc
      unifont
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Iosevka" ];
        sansSerif = [ "Roboto" ];
        serif = [ "Roboto Slab" ];
      };
    };
    enableDefaultFonts = true;
  };
}
