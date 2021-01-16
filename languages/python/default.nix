{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python3
    python
    python27Packages.pyudev
    python38Packages.pyudev
    python27Packages.pip
    python38Packages.pip
    python27Packages.pip-tools
    python38Packages.pip-tools
    python27Packages.setuptools
    python38Packages.setuptools

  ];

}
