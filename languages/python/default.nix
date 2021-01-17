{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs.python38Packages; [
    python
    pip
    setuptools
    virtualenv
  ];

}
