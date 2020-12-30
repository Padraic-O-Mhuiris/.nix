{ config, lib, pkgs, ... }:

let color = (import ./theme.nix).color;

in {
  xresources.properties = {
    "*foreground" = color 4;
    "*background" = color 0;
    "*cursorColor" = color 4;
    "*fadeColor" = color 3;
    "*color0" = color 1;
    "*color1" = color 11;
    "*color2" = color 14;
    "*color3" = color 13;
    "*color4" = color 9;
    "*color5" = color 15;
    "*color6" = color 8;
    "*color7" = color 5;
    "*color8" = color 3;
    "*color9" = color 11;
    "*color10" = color 14;
    "*color11" = color 13;
    "*color12" = color 9;
    "*color13" = color 15;
    "*color14" = color 7;
    "*color15" = color 6;

    "rofi.color-window" = "${color 0}, ${color 0}, ${color 14}";
    "rofi.color-normal" =
      "${color 0}, ${color 6}, ${color 0}, ${color 14}, ${color 0}";
    "rofi.color-active" =
      "${color 0}, ${color 6}, ${color 0}, ${color 14}, ${color 0}";
    "rofi.color-urgent" =
      "${color 0}, ${color 11}, ${color 0}, ${color 11}, ${color 6}";

  };
}
