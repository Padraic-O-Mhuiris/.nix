{ pkgs, config, lib, ... }: {
  fonts = {
    fonts = with pkgs; [ iosevka nerdfonts roboto ];
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
