{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    shellAliases = {ll = "ls -l";};
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = ["main" "brackets" "cursor" "line"];
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
      customPkgs = with pkgs; [nix-zsh-completions];
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$all";
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

  home.configFile = {
    "zsh/.zshrc".text = ''
      eval "$(direnv hook zsh)"
    '';
  };

  users.defaultUserShell = pkgs.zsh;
}
