{ config, lib, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./networking.nix
    ./fonts.nix
    ./keyboard.nix

    ./i3.nix

    # dev
    ./dev/editors/emacs.nix
    ./dev/editors/vim.nix
    ./dev/languages/rust.nix
    ./dev/languages/python.nix
    ./dev/languages/javascript.nix

    # tools
    ./tools/pass.nix
    ./tools/gpg.nix
    ./tools/git.nix
    ./tools/redshift.nix
    ./tools/fileManager.nix

    # apps
    ./apps/bitwarden.nix
    ./apps/spotify.nix
    ./apps/telegram.nix

    # cli
    ./cli/alacritty.nix
    ./cli/zsh.nix
  ];

  user = {
    name = "padraic";
    fullName = "Pádraic Ó Mhuiris";
    password =
      "$6$WKUDwwy/o3eiT$6UlydAIEdlQR9giydcDDKxiyI7z7RZZThEAOyk192AmmQC5Mqo0TJcglb85IJH69/UOWKNY322l2SzMntZ0Ck1";
    email = "patrick.morris.310@gmail.com";
    github = "Padraic-O-Mhuiris";
    publicKey = "9A51DBF629888EE75982008D9DCE7055406806F8";
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
  };
}
