{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.pass;
in {
  options.modules.shell.pass = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    env = {
      PASSWORD_STORE_DIR = "$HOME/.secrets";
      PASSWORD_STORE_TOMB_FILE = "$HOME/.secrets/graveyard.tomb";
      PASSWORD_STORE_TOMB_KEY = "/run/media/padraic/SHOVEL/shovel.tomb";
    };

    user.packages = with pkgs; [
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

  };
}
