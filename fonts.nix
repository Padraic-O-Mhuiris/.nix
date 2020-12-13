{ pkgs, config, lib, ... }: {
  fonts = {
    fonts = with pkgs; [
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
      iosevka
      emacs-all-the-icons-fonts
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Iosevka 13"];
        sansSerif = ["Iosevka 13"];
        serif = ["Iosevka Slab 13"];
      };
    };
    enableDefaultFonts = true;
  };
}
