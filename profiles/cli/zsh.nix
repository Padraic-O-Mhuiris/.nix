{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = { ll = "ls -l"; };
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = [ "main" "brackets" "cursor" "line" ];
    history = {
      size = 10000;
      path = "$XDG_CACHE_HOME/zhistory";
    };
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "dirhistory"
        "colored-man-pages"
        "command-not-found"
        "extract"
        "nix"
      ];
      customPkgs = with pkgs; [ nix-zsh-completions ];
    };
  };

  env = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
    ZSH_CACHE = "$XDG_CACHE_HOME/zsh";
    ZGEN_DIR = "$XDG_DATA_HOME/zsh";
    ZGEN_SOURCE = "$ZGEN_DIR/zgen.zsh";
  };

  user.packages = with pkgs; [
    zsh
    nix-zsh-completions
    bat
    exa
    fasd
    fd
    fzf
    tldr
    ripgrep
    fortune
    cowsay
    doge
    lolcat
    screenfetch
  ];

  users.defaultUserShell = pkgs.zsh;
}
