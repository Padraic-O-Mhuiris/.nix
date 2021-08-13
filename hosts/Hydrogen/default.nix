# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  nix = { buildCores = 4; };

  imports = [ ./hardware-configuration.nix ../home.nix ];

  modules = {
    desktop = {
      hledger.enable = true;
      i3.enable = true;
      xmonad.enable = false;
      redshift.enable = true;
      fileManager.enable = true;
      telegram.enable = true;
      term = {
        default = "st";
        st.enable = true;
      };
      tools = {
        libreoffice.enable = true;
        dapptools.enable = true;
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
      git.enable = true;
      pass.enable = true;
    };
    services = { docker.enable = true; };
    theme.active = "alucard";
  };

  #sops.defaultSopsFile = ../../secrets.yaml;
  #sops.gnupgHome = "/home/padraic/.gnupg";
  #sops.sshKeyPaths = [];

  #sops.secrets.hello = {};

  # sops.secrets.hello.mode = "0440";
  # sops.secrets.hello.owner = config.users.users.padraic.name;

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  environment.systemPackages = with pkgs; [
    deluge
    vlc
    nixfmt
    flameshot
    acpi
    usbutils
    powertop
    xorg.libxcb
    libusb
    libcgroup
    libudev0-shim
  ];

  services.xserver = {
    enable = true;
    dpi = 180;
    displayManager = {
      autoLogin = {
        enable = true;
        user = config.user.name;
      };
    };
  };
}
