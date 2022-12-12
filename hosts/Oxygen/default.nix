{ config, lib, pkgs, ... }:

{
  imports = [
    ../../profiles/machine/pc/boot.nix
    ../../profiles/machine/pc/cpu.nix
    ../../profiles/machine/pc/filesystem.nix
    ../../profiles/machine/pc/kernel.nix
    ../../profiles/machine/pc/monitors.nix
    ../../profiles/machine/pc/zfs.nix

    #../../profiles/machine/nvidia.nix

    ../../profiles/system/aliases.nix
    ../../profiles/system/audio.nix
    ../../profiles/system/bluetooth.nix
    ../../profiles/system/ethereum.nix
    ../../profiles/system/keyboard.nix
    ../../profiles/system/locale.nix
    ../../profiles/system/networking.nix
    ../../profiles/system/secrets.nix
    ../../profiles/system/ssh.nix
    ../../profiles/system/virtualisation.nix

    ../../profiles/system/security/admin.nix
    #../../profiles/system/security/antivirus.nix
    #../../profiles/system/security/firewall.nix

    #../../profiles/ui/boot.nix
    ../../profiles/ui/backlight.nix
    ../../profiles/ui/cli.nix
    ../../profiles/ui/fonts.nix
    ../../profiles/ui/launcher.nix
    ../../profiles/ui/login.nix
    ../../profiles/ui/wm.nix

    ../../profiles/user/bittorrent.nix
    ../../profiles/user/bitwarden.nix
    ../../profiles/user/fileManager.nix
    ../../profiles/user/flameshot.nix
    ../../profiles/user/git.nix
    ../../profiles/user/gpg.nix
    ../../profiles/user/libreoffice.nix
    ../../profiles/user/login.nix
    ../../profiles/user/pass.nix
    ../../profiles/user/spotify.nix
    ../../profiles/user/steam.nix
    ../../profiles/user/telegram.nix
    ../../profiles/user/video.nix
    ../../profiles/user/zsh.nix
    ../../profiles/user/tmux.nix

    ../../profiles/user/browsers/brave.nix
    ../../profiles/user/browsers/firefox.nix

    ../../profiles/user/dev/bash.nix
    ../../profiles/user/dev/javascript.nix
    ../../profiles/user/dev/python.nix
    ../../profiles/user/dev/rust.nix
    ../../profiles/user/dev/solidity.nix

    ../../profiles/user/editors/emacs.nix
    ../../profiles/user/editors/neovim.nix
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  os = {
    machine.cores = 32;
    ui = {
      cli.font.size = 12;
      backlight.day = 1.0;
      backlight.night = 0.7;
    };
    user = {
      name = "padraic";
      email = "patrick.morris.310@gmail.com";
      github = "Padraic-O-Mhuiris";
      keys = {
        gpg = "9A51DBF629888EE75982008D9DCE7055406806F8";
        ssh =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7";
      };
      passwordFile = config.sops.secrets.user.path;
      editor = "emacs";
    };
  };

  system.stateVersion = "22.05";
}
