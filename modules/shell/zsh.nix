{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.zsh;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.zsh = with types; {
    enable = mkBoolOpt false;

    aliases = mkOpt (attrsOf (either str path)) { };

    rcInit = mkOpt' lines "" ''
      Zsh lines to be written to $XDG_CONFIG_HOME/zsh/extra.zshrc and sourced by
      $XDG_CONFIG_HOME/zsh/.zshrc
    '';
    envInit = mkOpt' lines "" ''
      Zsh lines to be written to $XDG_CONFIG_HOME/zsh/extra.zshenv and sourced
      by $XDG_CONFIG_HOME/zsh/.zshenv
    '';

    rcFiles = mkOpt (listOf (either str path)) [ ];
    envFiles = mkOpt (listOf (either str path)) [ ];
  };

  config = mkIf cfg.enable {

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

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      syntaxHighlighting.highlighters = [ "main" "brackets" "cursor" "line" ];
      histFile = "$XDG_CACHE_HOME/zhistory";
      histSize = 1000000000;
      interactiveShellInit = ''
        source "$(${pkgs.fzf}/bin/fzf-share)/key-bindings.zsh"
      '';
      ohMyZsh = {
        enable = false;
        plugins = [
          "git"
          "sudo"
          "dirhistory"
          "colored-man-pages"
          "command-not-found"
          "extract"
          "nix"
          "fzf"
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

    home.configFile = {

      # https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout
      "zsh/.zshrc".text = ''
        source "$ZDOTDIR/extra.zshrc";
        source "$ZDOTDIR/aliases.zsh";

        [ -f ~/.zshrc ] && source ~/.zshrc
      '';

      "zsh/.zshenv".text = ''
        [ -f "${"0:a:h"}/extra.zshenv" ] && source "${"0:a:h"}/extra.zshenv"
        [ -f ~/.zshenv ] && source ~/.zshenv

        echo
        screenfetch -t
        echo
        echo
        fortune | cowsay -f tux
      '';

      # "zsh" = {
      #   source = "${configDir}/zsh";
      #   recursive = true;
      # };

      # Why am I creating extra.zsh{rc,env} when I could be using extraInit?
      # Because extraInit generates those files in /etc/profile, and mine just
      # write the files to ~/.config/zsh; where it's easier to edit and tweak
      # them in case of issues or when experimenting.
      #
      "zsh/extra.zshrc".text = ''
        # This file was autogenerated, do not edit it!
        ${concatMapStrings (path: ''
          source '${path}'
        '') cfg.rcFiles}
        ${cfg.rcInit}
      '';

      "zsh/extra.zshenv".text = ''
        # This file is autogenerated, do not edit it!
        ${concatMapStrings (path: ''
          source '${path}'
        '') cfg.envFiles}
        ${cfg.envInit}
      '';

      "zsh/aliases.zsh".text = let
        aliasLines = mapAttrsToList (n: v: ''alias ${n}="${v}"'') cfg.aliases;
      in ''
        alias ..='cd ..'
        alias ...='cd ../..'
        alias ....='cd ../../..'
        alias pd='cd -'
        alias q=exit
        alias clr=clear
        alias rm='rm -i'
        alias cp='cp -i'
        alias mv='mv -i'
        alias shutdown='sudo shutdown'
        alias reboot='sudo reboot'
        alias ports='netstat -tulanp'

        ${concatStringsSep "\n" aliasLines}
      '';
    };

    system.userActivationScripts.cleanupZgen = "rm -fv $XDG_CACHE_HOME/zsh/*";
  };
}
