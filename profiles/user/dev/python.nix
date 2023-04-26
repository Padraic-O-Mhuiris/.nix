{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs; [
    nodePackages.pyright
    (python310.withPackages (p: with p; [ black ]))
  ];

}
