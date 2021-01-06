{ config, lib, pkgs, ... }:

{
  programs.urxvt = {
    enable = true;
    fonts = [
      "xft:Iosevka:regular:size=12"
      "xft:Iosevka:italic:size=12"
      "xft:Iosevka:bold:size=12"
      "xft:Iosevka:bold italic:size=12"
    ];
    keybindings = {
      "Shift-Control-C" = "eval:selection_to_clipboard";
      "Shift-Control-V" = "eval:paste_clipboard";
    };
    transparent = false;
    scroll.bar.enable = false;
    extraConfig = { "internalBorder" = 50; };
    iso14755 = false;
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    shellAliases = {
      ll = "ls -al";
      ".." = "cd ..";
    };
    enableCompletion = true;
    enableAutosuggestions = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "lambda";
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
  };
}
