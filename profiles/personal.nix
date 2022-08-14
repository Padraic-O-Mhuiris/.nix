{ config, lib, pkgs, ... }:

{
  imports = [
    ./base.nix
    ./networking.nix
    ./fonts.nix
    ./dev/editors/emacs.nix
    ./dev/editors/vim.nix
    ./dev/languages/rust.nix
    ./dev/languages/python.nix
    ./dev/languages/javascript.nix
  ];

  user = {
    name = "padraic";
    hashedPassword =
      "$6$WKUDwwy/o3eiT$6UlydAIEdlQR9giydcDDKxiyI7z7RZZThEAOyk192AmmQC5Mqo0TJcglb85IJH69/UOWKNY322l2SzMntZ0Ck1";
  };

  environment = {
    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
    };
  };

  env.PATH = config.env.PATH ++ [ "$XDG_BIN_HOME" ];

  env.EDITOR = "emacs";
}
