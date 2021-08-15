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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    version = 2;
    zfsSupport = true;
    efiSupport = true;
    device = "nodev";
    fontSize = 30;
    gfxmodeEfi = "1280x800";
    gfxmodeBios = "1280x800";
  };

  boot.zfs.enableUnstable = true;
  boot.zfs.requestEncryptionCredentials = true;
  boot.zfs.devNodes = "/dev/disk/by-path";

  boot.initrd.supportedFilesystems = [ "zfs" ]; # boot from zfs
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "zfs.zfs_arc_max=12884901888" ];
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  networking.hostId = "92c7e9d8";

}
