{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs.python38Packages;
    with pkgs.python27Packages; [
      python
      pip
      setuptools
      virtualenv
      pypiwin32
    ];

}
