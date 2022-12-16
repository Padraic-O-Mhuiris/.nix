{ config, lib, pkgs, ... }:

{
  imports = [
    ../../profiles/machine/aws.nix

    ../../profiles/system/aliases.nix
    #../../profiles/system/ethereum.nix
    ../../profiles/system/locale.nix
    #../../profiles/system/networking.nix
    ../../profiles/system/secrets.nix
    ../../profiles/system/ssh.nix
    #../../profiles/system/tailscale.nix

    ../../profiles/system/security/admin.nix
    #../../profiles/system/security/antivirus.nix
    ../../profiles/system/security/firewall.nix

    #../../profiles/user/git.nix
    #../../profiles/user/gpg.nix
    ../../profiles/user/pass.nix
    ../../profiles/user/tmux.nix
    ../../profiles/user/zsh.nix
  ];

  os = {
    machine.cores = 4;
    user = {
      name = "nixos";
      passwordFile = config.sops.secrets.user.path;
      editor = "vim";
      keys = {
        ssh =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7";
      };
    };
  };

  system.stateVersion = "22.11";
}