{ config, lib, pkgs, ... }:

{
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
}
