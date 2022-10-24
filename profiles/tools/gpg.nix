{
  config,
  lib,
  pkgs,
  ...
}: {
  env.GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";
  env.GPG_KEY = config.user.publicKey;

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
  services.udev.packages = with pkgs; [yubikey-personalization libu2f-host];

  home.configFile."gnupg/gpg-agent.conf" = {
    text = ''
      default-cache-ttl 3600
      pinentry-program ${pkgs.pinentry.gtk2}/bin/pinentry
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };
}
