{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.gnupg;
in {
  options.modules.shell.gnupg = with types; {
    enable = mkBoolOpt false;
    cacheTTL = mkOpt int 3600; # 1hr
    gpgPublicKey = mkOpt str "9A51DBF629888EE75982008D9DCE7055406806F8";
  };

  config = mkIf cfg.enable {
    env.GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";
    env.GPG_KEY = cfg.gpgPublicKey;

    programs.gnupg.agent = {
      enable = true;
      enableExtraSocket = true;
      enableBrowserSocket = true;
      pinentryFlavor = "gtk2";
    };

    user.packages = with pkgs; [
      pinentry
      pinentry-gnome
      pinentry-curses
      paperkey
      yubikey-personalization
      yubikey-manager
    ];
    services.pcscd.enable = true;
    services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];

    home.configFile."gnupg/gpg-agent.conf" = {
      text = ''
        default-cache-ttl ${toString cfg.cacheTTL}
        pinentry-program ${pkgs.pinentry.gtk2}/bin/pinentry
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
    };
  };
}
