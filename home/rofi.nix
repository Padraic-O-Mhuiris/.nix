{ config, lib, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    scrollbar = false;
    width = 1000;
    font = "Iosevka 25";
    theme = builtins.toString (pkgs.writeText "rofi-theme" ''
      configuration {
        display-drun:    "Apps";
        display-run:     "Exec";
        display-window:  "Open";
        show-icons:      true;
      }
    '');
  };
}
