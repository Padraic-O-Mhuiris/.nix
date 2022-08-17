{ config, lib, pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;
    nameservers = [ "1.1.1.1" "9.9.9.9" ];
    hosts = { "127.0.0.1" = [ config.networking.hostName ]; };
  };
  programs.nm-applet.enable = true;

  # TODO Make a config module for managing ssh secrets
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
    hostKeys = [{
      type = "ed25519";
      path = "/etc/ssh/ssh_host_ed25519_key";
      rounds = 100;
      comment = "${config.networking.hostName}";
    }];
  };

  users.users.${config.user.name}.openssh.authorizedKeys.keys =
    config.user.ssh.authorizedKeys;
}
