{ pkgs, ... }:

{
  imports = [
    ./xresources.nix
    ./browser.nix
    ./terminal.nix
    ./i3.nix
    ./vim.nix
    ./rofi.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.keyboard = null;

  home.packages = with pkgs; [
    ranger
    i3lock
    redshift
    spotify
    zoom-us
    libreoffice
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

  programs.feh.enable = true;
  programs.zsh = { enable = true; };

  services.udiskie = {
    enable = true;
    notify = false;
  };
}
