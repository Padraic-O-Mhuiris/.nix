{ config, lib, pkgs, ... }: { user.packages = with pkgs; [ bitwarden ]; }
