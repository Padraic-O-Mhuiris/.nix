{ config, lib, pkgs, ... }:

let
  pythonPkgs = pkgs.python310.withPackages
    (p: with p; [ black poetry pip cython pytest nose pyflakes isort ]);
in {
  os.user.packages = with pkgs; [
    pythonPkgs
    python-language-server
    nodePackages.pyright
    pipenv
    fava
    beancount
    beancount-language-server
  ];
}
