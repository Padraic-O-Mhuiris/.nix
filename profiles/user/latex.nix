{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs; [ texlive.combined.scheme-medium ];
}
