{ pkgs, config, lib, ... }: {
  fonts = {
    fonts = with pkgs; [
      iosevka
      nerd-fonts
      roboto
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
