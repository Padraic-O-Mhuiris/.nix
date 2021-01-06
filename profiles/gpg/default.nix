{ config, lib, pkgs, ... }:

{
  services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];
  services.pcscd.enable = true;
  environment.systemPackages = with pkgs; [ yubikey-personalization ];

  home-manager.users.padraic = {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 43200;
      defaultCacheTtlSsh = 43200;
      maxCacheTtl = 43200;
      maxCacheTtlSsh = 43200;
      enableExtraSocket = true;

      pinentryFlavor = "gnome3";
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
