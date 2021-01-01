{ pkgs, ... }:

{

  imports = [
    ./gpg.nix
    ./xresources.nix
    ./browser.nix
    ./emacs
    ./terminal.nix
    ./i3.nix
    ./vim.nix
    ./rofi.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.keyboard = null;

  home.packages = with pkgs; [
    #spotify
    #dapptools.seth
    #dapptools.dapp
    ranger
    i3lock
    redshift
    #libreoffice
    gnome3.evince
    gnome3.nautilus
    pavucontrol
    isync
    mu
  ];
  home.stateVersion = "20.09";
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

  programs.feh.enable = true;
  programs.zsh = {
    enable = true;
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
