{ config, lib, pkgs, ... }:

{
  # Todo make desktop item with appropriate scaling
  user.packages = with pkgs; [ spotify ];
}
