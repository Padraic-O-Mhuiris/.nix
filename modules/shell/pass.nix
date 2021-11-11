{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.pass;
  gnupgCfg = config.modules.shell.gnupg;
in {
  options.modules.shell.pass = with types; { enable = mkBoolOpt false; };

  config = mkIf (cfg.enable && gnupgCfg.enable) {

    env = {
      PASSWORD_STORE_KEY = gnupgCfg.gpgPublicKey;
      PASSWORD_STORE_DIR = "$HOME/.secrets";
      #PASSWORD_STORE_TOMB_FILE = "$HOME/.secrets/${gnupgCfg.gpgPublicKey}.tomb";
      #PASSWORD_STORE_TOMB_KEY =
      #  "/run/media/padraic/SHOVEL/${gnupgCfg.gpgPublicKey}.shovel.tomb";
    };

    user.packages = with pkgs; [
      (pass.withExtensions (ext:
        with ext; [
          pass-audit
          pass-otp
          pass-import
          pass-genphrase
          pass-update
          #pass-tomb
        ]))
      bitwarden
    ];
  };
}
