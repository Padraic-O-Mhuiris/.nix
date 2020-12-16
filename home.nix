{ pkgs, ... }:

let
  dapptools = import (builtins.fetchTarball {
    url = "https://github.com/dapphub/dapptools/tarball/master";
  }) { };

in {
  imports =
    [ ./emacs.nix ./terminal.nix ./gpg.nix ./i3.nix ./monitors.nix ./rofi.nix ];

  nixpkgs.config.allowUnfree = true;

  home.keyboard = null;

  home.packages = with pkgs; [
    spotify
    nodejs
    yarn
    dapptools.seth
    dapptools.dapp
    ranger
  ];

  home.file.".icons/default".source =

    "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";
  home.file.".config/udiskie/config.yml".text = ''
    device_config:
      - device_file: /dev/loop0
        ignore: true
  '';

  programs.git = {
    enable = true;
    userName = "Padraic-O-Mhuiris";
    userEmail = "patrick.morris.310@gmail.com";
    signing = {
      key = "0xBD01159F2C44F16B";
      signByDefault = true;
    };
    extraConfig = { http = { postBuffer = "524288000"; }; };
  };

  programs.google-chrome.enable = true;
  programs.gpg.enable = true;
  programs.feh.enable = true;
  programs.zsh = {
    enable = true;
    initExtra = ''
      export PATH="$PATH:`yarn global bin`"
    '';
  };

  services.udiskie = {
    enable = true;
    notify = false;
  };

  home.sessionVariables = {
    PASSWORD_STORE_DIR = "$HOME/.secrets";
    PASSWORD_STORE_TOMB_FILE = "$HOME/.secrets/graveyard.tomb";
    PASSWORD_STORE_TOMB_KEY = "/run/media/padraic/Backup/shovel.tomb";
  };
}
