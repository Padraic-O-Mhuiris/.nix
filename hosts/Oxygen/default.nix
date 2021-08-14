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
      emacs.enable = false;
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

  services.xserver.videoDrivers = [ "nvidia" ];
  networking.hostId = "0b73d82f";

  #sops.defaultSopsFile = ../../secrets.yaml;
  #sops.gnupgHome = "/home/padraic/.gnupg";
  #sops.sshKeyPaths = [];

  #sops.secrets.hello = {};

  # sops.secrets.hello.mode = "0440";
  # sops.secrets.hello.owner = config.users.users.padraic.name;
}
