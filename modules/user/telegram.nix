{ config, lib, pkgs, ... }:

{
  os.user.packages = with pkgs; [ tdesktop ];
}
