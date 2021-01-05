{ config, lib, pkgs, ... }:

let
  inherit (builtins) fetchGit;

  test =
    (import (fetchGit "ssh://git@github.com/Padraic-O-Mhuiris/.secrets.git"));

in {

  environment.systemPackages = with pkgs; [
    tomb
    (pass.withExtensions (ext:
      with ext; [
        pass-audit
        pass-otp
        pass-import
        pass-genphrase
        pass-update
        pass-tomb
      ]))
  ];

  home-manager.users.padraic = {
    home.sessionVariables = {
      PASSWORD_STORE_DIR = "$HOME/.secrets";
      PASSWORD_STORE_TOMB_FILE = "$HOME/.secrets/graveyard.tomb";
      PASSWORD_STORE_TOMB_KEY = "/run/media/padraic/Backup/shovel.tomb";
    };

    home.file.".secrets".source = test;
  };
}
