{ config, lib, pkgs, ... }:

{
  programs.urxvt = {
    enable = true;
    fonts = [
      "xft:Iosevka Term:regular:size=12"
      "xft:Iosevka Term:italic:size=12"
      "xft:Iosevka Term:bold:size=12"
      "xft:Iosevka Term:bold italic:size=12"
    ];
    keybindings = {
      "Shift-Control-C" = "eval:selection_to_clipboard";
      "Shift-Control-V" = "eval:paste_clipboard";
    };
    transparent = false;
    scroll.bar.enable = false;
    extraConfig = { "internalBorder" = 50; };
    iso14755 = true;
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

}
