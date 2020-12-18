{ pkgs, config, lib, ... }: {
  fonts = {
    fonts = with pkgs; [
      iosevka
      terminus_font
      opensans-ttf
      roboto
      roboto-mono
      roboto-slab
      nerdfonts
      noto-fonts
      noto-fonts-emoji
      hasklig
      material-design-icons
      material-icons
      emacs-all-the-icons-fonts
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Iosevka Slab" ];
        sansSerif = [ "Roboto" ];
        serif = [ "Roboto Slab" ];
      };
    };
    enableDefaultFonts = true;
  };
}
