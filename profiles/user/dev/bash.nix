{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs; [ nodePackages.bash-language-server ];
}
