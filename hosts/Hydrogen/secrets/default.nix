{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ age sops ssh-to-age ];
  sops.defaultSopsFile = ./secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets.user.neededForUsers = true;
}
