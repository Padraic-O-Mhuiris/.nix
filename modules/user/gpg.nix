{ config, lib, pkgs, ... }:

{
  environment.sessionVariables = { GNUPGHOME = "$XDG_CONFIG_HOME/gnupg"; };

  programs.gnupg.agent = {
    enable = true;
    enableExtraSocket = true;
    enableBrowserSocket = true;
    pinentryFlavor = "gtk2";
  };

  os.user.packages = with pkgs; [
    pinentry
    pinentry-gnome
    pinentry-curses
    paperkey
    yubikey-personalization
    yubikey-manager
  ];
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];

  os.user.home.configFile."gnupg/gpg-agent.conf".text = ''
    default-cache-ttl 3600
    pinentry-program ${pkgs.pinentry.gtk2}/bin/pinentry
    allow-emacs-pinentry
    allow-loopback-pinentry
  '';
}
