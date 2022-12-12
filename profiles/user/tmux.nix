{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    shortcut = "a";
    escapeTime = 0;
    secureSocket = false; # persists user logout
    keyMode = "vi";
  };
}
