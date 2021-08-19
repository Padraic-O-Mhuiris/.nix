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
      hledger.enable = true;
      xmonad.enable = false;
      redshift.enable = true;
      fileManager.enable = true;
      telegram.enable = true;
      term = {
        default = "xst";
        st.enable = true;
      };
      apps = {
        steam.enable = true;
        libreoffice.enable = true;
        rofi.enable = true;
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
        haskell.enable = false;
      };
    };
    shell = {
      gnupg.enable = true;
      zsh.enable = true;
      git.enable = true;
      pass.enable = true;
      dapptools.enable = true;
      direnv.enable = true;
    };
    services = { docker.enable = true; };
    theme.active = "alucard";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.zfs.enableUnstable = true;
  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.devNodes = "/dev/disk/by-path";

  boot.initrd.supportedFilesystems = [ "zfs" ]; # boot from zfs
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "zfs.zfs_arc_max=12884901888" ];
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

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
