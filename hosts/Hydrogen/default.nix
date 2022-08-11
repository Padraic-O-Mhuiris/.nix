{ config, pkgs, lib, inputs, ... }:

{
  nix = { buildCores = 4; };

  imports = [ ./hardware-configuration.nix ./zfs.nix ../home.nix ];

  modules = {
    hardware = {
      audio.enable = true;
      fs.enable = true;
      bluetooth = {
        enable = true;
	audio.enable = true;
      };
      wallet.enable = true;
      printing.enable = true;
      keyboard.enable = true;
    };
    desktop = {
      monitors = {
        enable = true;
        primary = "eDP-1";
        mode = "3840x2400";
        rate = 60;
      };
      i3 = {
        enable = true;
        dpi = 110;
      };
      xmonad.enable = false;
      redshift.enable = true;
      fileManager.enable = true;
      telegram.enable = true;
      term = {
        default = "alacritty";
        alacritty.enable = true;
      };
      apps = {
        ledger.enable = true;
        libreoffice.enable = true;
        rofi.enable = true;
        zoom.enable = true;
        teams.enable = true;
      };
      media = { spotify.enable = true; };
      browser = {
        default = "brave";
        firefox.enable = true;
        brave.enable = true;
      };
    };
    editors = {
      default = "nvim";
      vim.enable = true;
      emacs.enable = true;
      languages = {
        javascript.enable = true;
        python.enable = true;
      };
    };
    shell = {
      gnupg.enable = true;
      zsh.enable = true;
      ssh.enable = true;
      git.enable = true;
      pass.enable = true;
      dapptools.enable = true;
      direnv.enable = true;
    };
    services = {
      docker.enable = true;
      syncthing.enable = true;
    };
    theme.active = "alucard";
  };
}
