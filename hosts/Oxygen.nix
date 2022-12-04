{ config, lib, pkgs, ... }:

{
  imports = [
    ../modules/machine/pc/boot.nix
    ../modules/machine/pc/cpu.nix
    ../modules/machine/pc/filesystem.nix
    ../modules/machine/pc/kernel.nix
    ../modules/machine/pc/monitors.nix
    ../modules/machine/pc/zfs.nix

    ../modules/machine/nvidia.nix

    ../modules/system/aliases.nix
    ../modules/system/audio.nix
    ../modules/system/bluetooth.nix
    ../modules/system/keyboard.nix
    ../modules/system/networking.nix
    ../modules/system/ssh.nix
    ../modules/system/virtualisation.nix

    ../modules/system/security/admin.nix
    ../modules/system/security/antivirus.nix
    ../modules/system/security/firewall.nix

    ../modules/ui/boot.nix
    ../modules/ui/cli.nix
    ../modules/ui/fonts.nix
    ../modules/ui/launcher.nix
    ../modules/ui/login.nix
    ../modules/ui/wm.nix

    ../modules/user/bittorrent.nix
    ../modules/user/bitwarden.nix
    ../modules/user/fileManager.nix
    ../modules/user/flameshot.nix
    ../modules/user/git.nix
    ../modules/user/gpg.nix
    ../modules/user/libreoffice.nix
    ../modules/user/login.nix
    ../modules/user/pass.nix
    ../modules/user/redshift.nix
    ../modules/user/spotify.nix
    ../modules/user/steam.nix
    ../modules/user/telegram.nix
    ../modules/user/video.nix

    ../modules/user/browsers/brave.nix
    ../modules/user/browsers/firefox.nix

    ../modules/user/dev/javascript.nix
    ../modules/user/dev/python.nix
    ../modules/user/dev/rust.nix
    ../modules/user/dev/bash.nix

    ../modules/user/editors/emacs.nix
    ../modules/user/editors/neovim.nix

  ];

  time.timeZone = "Europe/Dublin";
  i18n.defaultLocale = "en_IE.UTF-8";

  location = {
    latitude = 53.28;
    longitude = -9.03;
  };

  os = {
    machine.cores = 32;
    user = {
      name = "padraic";
      email = "patrick.morris.310@gmail.com";
      github = "Padraic-O-Mhuiris";
      keys = {
        gpg = "9A51DBF629888EE75982008D9DCE7055406806F8";
        ssh =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7";
      };
      hashedPassword =
        "$6$WKUDwwy/o3eiT$6UlydAIEdlQR9giydcDDKxiyI7z7RZZThEAOyk192AmmQC5Mqo0TJcglb85IJH69/UOWKNY322l2SzMntZ0Ck1";
      editor = "emacs";
    };
  };

  system.stateVersion = "22.05";
}
