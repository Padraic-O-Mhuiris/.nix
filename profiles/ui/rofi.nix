{
  config,
  lib,
  pkgs,
  ...
}: {
  user.packages = with pkgs; [rofi];
}
