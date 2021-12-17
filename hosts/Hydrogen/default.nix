{ config, pkgs, lib, inputs, ... }:

{
  nix = { buildCores = 4; };

  imports = [ ./hardware-configuration.nix ../home.nix ];

  modules = {
    desktop = {
      monitors = {
        enable = true;
        primary = "eDP-1";
        mode = "3840x2160";
        rate = 60;
      };
      hledger.enable = true;
      i3 = {
        enable = true;
        dpi = 180;
      };
      xmonad.enable = false;
      redshift.enable = true;
      fileManager.enable = true;
      telegram.enable = true;
      term = {
        default = "xst";
        st.enable = true;
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
      ssh.enable = true;
      ssh.sshConfigFile = config.age.secrets.sshConfig.path;
      zsh.enable = true;
      git.enable = true;
      pass.enable = true;
      dapptools.enable = true;
      direnv.enable = true;
    };
    services = {
      docker.enable = true;
      syncthing.enable = true;
      beacon-chain.enable = true;
    };
    theme.active = "alucard";
  };
}
