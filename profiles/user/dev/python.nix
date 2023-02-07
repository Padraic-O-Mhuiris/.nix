{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs; [
    python-language-server
    nodePackages.pyright
    (python310.withPackages (p: with p; [ black ]))
  ];

}
