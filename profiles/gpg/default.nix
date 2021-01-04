{ config, lib, pkgs, ... }:

{
  services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];
  services.pcscd.enable = true;
  environment.systemPackages = with pkgs; [ yubikey-personalization ];

  home-manager.users.padraic = {
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
      sshKeys = [ "D63534360EC2DB415ADB3A301D3DDF5660F23479" ];
    };
    programs.gpg = { enable = true; };
  };
}
