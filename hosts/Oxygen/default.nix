{ config, pkgs, lib, inputs, ... }:

{
  nix = { buildCores = 16; };

  imports = [ ./hardware-configuration.nix ../home.nix ];

  modules = {
    desktop = {
      monitors = {
        enable = true;
        primary = "DP-0";
        mode = "5120x1440";
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
      matrix.enable = true;
      term = {
        default = "alacritty";
        xst.enable = true;
        alacritty.enable = true;
      };
      apps = {
        ledger.enable = true;
        steam.enable = true;
        libreoffice.enable = true;
        rofi.enable = true;
        gimp.enable = true;
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
        rust.enable = true;
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
      ngrok.enable = true;
      ngrok.configFile = config.age.secrets.ngrokConfig.path;
      docker.enable = true;
      syncthing.enable = true;
      geth.enable = true;
      finances.enable = false;
      eth2-node.enable = true;
      eth2-node.passwordFile = config.age.secrets.validatorPassword.path;
    };
    theme.active = "alucard";
  };

  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.zfs.enableUnstable = true;
  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.devNodes = "/dev/disk/by-path";

  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "zfs.zfs_arc_max=12884901888" ];
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  powerManagement.enable = true;

  modules.hardware = {
    audio.enable = true;
    fs.enable = true;
    bluetooth = {
      enable = true;
      audio.enable = true;
    };
    grub.enable = true;
    wallet.enable = true;
    printing.enable = true;
    keyboard.enable = true;
  };

}
