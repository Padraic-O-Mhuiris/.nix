{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python3
    python
    python27Packages.pyudev
    python37Packages.pyudev
  ];

}