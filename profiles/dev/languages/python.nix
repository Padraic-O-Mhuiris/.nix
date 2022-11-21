{ config, lib, pkgs, ... }:

let
  pythonPkgs = pkgs.python310.withPackages
    (p: with p; [ black poetry pip cython pytest nose pyflakes isort conda ]);
in {
  user.packages = [
    pythonPkgs
    pkgs.python-language-server
    pkgs.nodePackages.pyright
    pkgs.pipenv
  ];
}
