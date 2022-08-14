{ config, lib, pkgs, ... }:

{
  env = {
    PASSWORD_STORE_KEY = config.user.publicKey;
    PASSWORD_STORE_DIR = "$HOME/.secrets";
  };

  user.packages = with pkgs;
    [
      (pass.withExtensions (ext:
        with ext; [
          pass-audit
          pass-otp
          pass-import
          pass-genphrase
          pass-update
        ]))
    ];
}
