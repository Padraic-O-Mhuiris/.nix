{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = { ll = "ls -l"; };
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = [ "main" "brackets" "cursor" "line" ];
    histFile = "$XDG_CACHE_HOME/zhistory";
    histSize = 100000;
    interactiveShellInit = ''
      source "$(${pkgs.fzf}/bin/fzf-share)/key-bindings.zsh"
    '';
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "aliases"
        "sudo"
        "direnv"
        "emacs"
        "emoji"
        "encode64"
        "jsontools"
        "systemd"
        "dirhistory"
        "colored-man-pages"
        "command-not-found"
        "extract"
        "nix"
      ];
      customPkgs = with pkgs; [ nix-zsh-completions ];
    };
  };
}
