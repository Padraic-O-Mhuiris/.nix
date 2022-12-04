{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs; [ rofi ];

  os.user.home.configFile."rofi/config.rasi" = "\n\n  ";
}
