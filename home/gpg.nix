{ config, lib, pkgs, ... }:

{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 600;
    defaultCacheTtlSsh = 600;
    maxCacheTtl = 7200;
    maxCacheTtlSsh = 7200;
    enableExtraSocket = true;
    pinentryFlavor = "curses";
    extraConfig = ''
      pinentry-timeout 100
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };
  programs.gpg = { enable = true; };
}
