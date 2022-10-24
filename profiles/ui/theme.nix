{
  config,
  lib,
  pkgs,
  ...
}: let
  gtkTheme = "Dracula";
  gtkIconTheme = "Paper";
  gtkCursorTheme = "Paper";
in {
  home.configFile = {
    # GTK
    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${gtkTheme}
      gtk-icon-theme-name=${gtkIconTheme}
      gtk-cursor-theme-name=${gtkCursorTheme}
      gtk-fallback-icon-theme=gnome
      gtk-application-prefer-dark-theme=true
      gtk-xft-hinting=1
      gtk-xft-hintstyle=hintfull
      gtk-xft-rgba=none
    '';

    "gtk-2.0/gtkrc".text = ''
      gtk-theme-name=${gtkTheme}
      gtk-icon-theme-name="${gtkIconTheme}
      gtk-font-name="Sans 10"
    '';
  };
  user.packages = with pkgs; [dracula-theme paper-icon-theme];
}
