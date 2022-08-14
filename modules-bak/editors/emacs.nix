{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editors.emacs;
  configDir = config.dotfiles.configDir;
in {
  options.modules.editors.emacs = {
    enable = mkBoolOpt false;
    doom = {
      enable = mkBoolOpt true;
      fromSSH = mkBoolOpt false;
    };
  };

  config = mkIf cfg.enable {

    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

    services.emacs = {
      enable = true;
      package = pkgs.emacsNativeComp;
    };

    user.packages = with pkgs; [
      binutils # native-comp needs 'as', provided by this

      ## Doom dependencies
      git
      (ripgrep.override { withPCRE2 = true; })
      gnutls # for TLS connectivity

      shellcheck

      scrot
      ## Optional dependencies
      fd # faster projectile indexing
      imagemagick # for image-dired
      (mkIf (config.programs.gnupg.agent.enable)
        pinentry_emacs) # in-emacs gnupg prompts
      zstd # for undo-fu-session/undo-tree compression

      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      # :checkers grammar
      languagetool
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      sqlite
      # :lang cc
      ccls
      # :lang javascript
      nodePackages.javascript-typescript-langserver
      nodePackages.beancount-langserver
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :lang rust
      rustfmt
      unstable.rust-analyzer
      # :lang haskell
      libical
      libudev0-shim

      # TODO may not be necessary for org-roam
      postgresql
      graphviz
      pandoc
      wordnet
      nixfmt
      jupyter

      anystyle-cli

      #org-mode
      proselint
      texlive.combined.scheme-full

    ];

    #env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

    # init.doomEmacs = mkIf cfg.doom.enable ''
    #   if [ -d $HOME/.config/emacs ]; then
    #      ${optionalString cfg.doom.fromSSH ''
    #         git clone git@github.com:hlissner/doom-emacs.git $HOME/.config/emacs
    #         git clone git@github.com:hlissner/doom-emacs-private.git $HOME/.config/doom
    #      ''}
    #      ${optionalString (cfg.doom.fromSSH == false) ''
    #         git clone https://github.com/hlissner/doom-emacs $HOME/.config/emacs
    #         git clone https://github.com/hlissner/doom-emacs-private $HOME/.config/doom
    #      ''}
    #   fi
    # '';
  };
}