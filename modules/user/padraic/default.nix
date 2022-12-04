{ config, lib, pkgs, ... }:

{
  imports = [
    ../bittorrent.nix
    ../bitwarden.nix
    ../fileManager.nix
    ../flameshot.nix
    ../git.nix
    ../gpg.nix
    ../libreoffice.nix
    ../login.nix
    ../pass.nix
    ../redshift.nix
    ../spotify.nix
    ../steam.nix
    ../telegram.nix
    ../video.nix

    ../browsers/brave.nix
    ../browsers/firefox.nix

    ../dev/javascript.nix
    ../dev/python.nix
    ../dev/rust.nix
    ../dev/bash.nix

    ../editors/emacs.nix
    ../editors/neovim.nix
  ];

  os.user = {
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
}
