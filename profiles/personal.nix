{ config, lib, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./networking.nix
    ./fonts.nix
    ./keyboard.nix
    ./browser.nix
    ./agenix.nix

    # dev
    ./dev/editors/emacs.nix
    ./dev/editors/vim.nix
    ./dev/languages/rust.nix
    ./dev/languages/javascript.nix

    # tools
    ./tools/pass.nix
    ./tools/gpg.nix
    ./tools/git.nix
    ./tools/redshift.nix
    ./tools/fileManager.nix
    ./tools/flameshot.nix

    # apps
    ./apps/bitwarden.nix
    ./apps/spotify.nix
    ./apps/telegram.nix
    # cli
    ./cli/alacritty.nix
    ./cli/zsh.nix

    ./audio.nix

    ./ui
  ];

  user = {
    name = "padraic";
    fullName = "Pádraic Ó Mhuiris";
    password =
      "$6$WKUDwwy/o3eiT$6UlydAIEdlQR9giydcDDKxiyI7z7RZZThEAOyk192AmmQC5Mqo0TJcglb85IJH69/UOWKNY322l2SzMntZ0Ck1";
    email = "patrick.morris.310@gmail.com";
    github = "Padraic-O-Mhuiris";
    publicKey = "9A51DBF629888EE75982008D9DCE7055406806F8";
    ssh.authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7 padraic-o-mhuiris@protonmail.com"
    ];
  };

  environment = {
    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
    };
  };

  env = {
    PATH = [ "$XDG_BIN_HOME" ];
    EDITOR = "emacs";
    TERMINAL = "alacritty";
    BROWSER = "brave";
  };
}
