{ config, lib, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    openFirewall = !config.services.tailscale.enable;
    useDns = true;
    passwordAuthentication = false;
    permitRootLogin = lib.mkForce "no";
    hostKeys = [{
      type = "ed25519";
      path = "/etc/ssh/ssh_host_ed25519_key";
      rounds = 100;
      comment = "${config.networking.hostName}";
    }];
  };
  programs.ssh.startAgent = true;
}
