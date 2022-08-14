{ config, lib, pkgs, ... }:

{
  user.packages = with pkgs; [
    python39Full
    python-language-server
    nodePackages.pyright
    black
    python39Packages.nose
    python39Packages.isort
    python39Packages.pyflakes
    poetry
  ];
}
