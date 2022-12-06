{ config, lib, pkgs, ... }:

{
  environment.sessionVariables = {
    PASSWORD_STORE_KEY = config.os.user.keys.gpg;
    PASSWORD_STORE_DIR = "$HOME/.secrets";
  };

  os.user.packages = with pkgs;
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
