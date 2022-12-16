{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [ age sops ssh-to-age ];
  sops.defaultSopsFile = ../../hosts + "/${config.networking.hostName}.yaml";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # user secret will always be needed
  sops.secrets.user.neededForUsers = true;
}
