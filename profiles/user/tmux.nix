{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    shortcut = "a";
    escapeTime = 0;
    secureSocket = false; # persists user logout
    keyMode = "vi";
    plugins = with pkgs; [ tmuxPlugins.better-mouse-mode ];
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      set-option -g mouse on

    '';
  };
}
