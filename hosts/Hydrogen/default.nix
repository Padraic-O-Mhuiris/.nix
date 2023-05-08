{ config, lib, pkgs, ... }:

{
  imports = [
    ../../profiles/machine/laptop/boot.nix
    ../../profiles/machine/laptop/cpu.nix
    ../../profiles/machine/laptop/filesystem.nix
    ../../profiles/machine/laptop/hardware.nix
    ../../profiles/machine/laptop/kernel.nix

    ../../profiles/machine/nvidia.nix

    ../../profiles/system/aliases.nix
    ../../profiles/system/audio.nix
    ../../profiles/system/bluetooth.nix
    ../../profiles/system/health.nix
    ../../profiles/system/keyboard.nix
    ../../profiles/system/locale.nix
    ../../profiles/system/networking.nix
    ../../profiles/system/secrets.nix

    ../../profiles/system/ssh.nix

    ../../profiles/system/tailscale.nix
    ../../profiles/system/virtualisation.nix

    ../../profiles/system/security/admin.nix
    ../../profiles/system/security/antivirus.nix
    ../../profiles/system/security/firewall.nix

    #../../profiles/ui/boot.nix
    ../../profiles/ui/backlight.nix
    ../../profiles/ui/cli.nix
    ../../profiles/ui/fonts.nix
    ../../profiles/ui/launcher.nix
    ../../profiles/ui/wm/i3.nix

    ../../profiles/user/bittorrent.nix
    ../../profiles/user/bitwarden.nix
    ../../profiles/user/deploy.nix
    ../../profiles/user/direnv.nix
    ../../profiles/user/fileManager.nix
    ../../profiles/user/flameshot.nix
    ../../profiles/user/git.nix
    ../../profiles/user/gpg.nix
    ../../profiles/user/graphviz.nix
    ../../profiles/user/latex.nix
    ../../profiles/user/libreoffice.nix
    ../../profiles/user/matrix.nix
    ../../profiles/user/pass.nix
    ../../profiles/user/steam.nix
    ../../profiles/user/telegram.nix
    ../../profiles/user/tmux.nix
    ../../profiles/user/video.nix
    ../../profiles/user/zsh.nix

    # ../../profiles/user/browsers/brave.nix
    ../../profiles/user/browsers/firefox.nix

    ../../profiles/user/dev/bash.nix
    ../../profiles/user/dev/javascript.nix
    ../../profiles/user/dev/python.nix
    # ../../profiles/user/dev/rust.nix
    ../../profiles/user/dev/bash.nix
    #../../profiles/user/dev/solidity.nix

    ../../profiles/user/editors/emacs.nix
    # ../../profiles/user/editors/neovim
    ../../profiles/user/editors/helix.nix
  ];

  os = {
    ui = {
      dpi = 180;
      cli.font.size = 7;
    };
    machine = { cores = 20; };
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
