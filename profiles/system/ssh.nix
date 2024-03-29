{ config, lib, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    openFirewall = !config.services.tailscale.enable;
    settings = {
      PermitRootLogin =
        if config.os.system.isDesktop then "no" else "prohibit-password";
      UseDns = true;
      PasswordAuthentication = false;
    };
    hostKeys = [{
      type = "ed25519";
      path = "/etc/ssh/ssh_host_ed25519_key";
      rounds = 100;
      comment = "${config.networking.hostName}";
    }];
  };

  users.users.root.openssh.authorizedKeys.keys =
    if config.os.system.isDesktop then [ ] else [ config.os.user.keys.ssh ];

  programs.ssh.startAgent = true;
}
