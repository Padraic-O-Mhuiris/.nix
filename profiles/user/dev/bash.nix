{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs.unstable; [ nodePackages.bash-language-server ];
}
