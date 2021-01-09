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

  systemd.user.services.projects = {
    Unit = {
      Description = "Clones project repositories from external sources";
      ConditionPathExists = "!$HOME/.finances";
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = false;
      ExecStart =
        "${pkgs.git}/bin/git clone git@github.com:Padraic-O-Mhuiris/.finance.git -O $HOME/.finance";
    };
    Install = { WantedBy = "default.target"; };
  };
}
