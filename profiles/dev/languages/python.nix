{ config, lib, pkgs, ... }: {
  user.packages = with pkgs;
    (let
      pythonPkgs = p:
        with p; [
          black
          poetry
          pip
          cython
          pytest
          nose
          pyflakes
          isort
          conda
        ];
    in python310.withPackages pythonPkgs)
    ++ [ python-language-server nodePackages.pyright pipenv ];
}
