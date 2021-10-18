{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.ssh;
  configDir = config.dotfiles.configDir;

  gpgSshKeyFile =
    "${config.dotfiles.keysDir}/gpg/9A51DBF629888EE75982008D9DCE7055406806F8_ssh_key";

  is_local_conn = pkgs.writeShellScriptBin "is_local_conn" ''
    nmcli -t -f active,ssid dev wifi | grep -q '^yes:VM9598311' && exit 0

    exit 1
  '';

in {
  options.modules.shell.ssh = {
    enable = mkBoolOpt false;
    enableRemoteAccess = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ ngrok is_local_conn ];

    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };

    users.users."${config.user.name}".openssh.authorizedKeys = {
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE6RXJPp92XKKfkIUpnnhX14FgqeFvcO/6JvZMTXkum7 Hydrogen - padraic-o-mhuiris@protonmail.com"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFHXnABspqcYysmEtN8zKAjrUyxKy5RXm740h3csJWqy Oxygen - padraic-o-mhuiris@protonmail.com"
      ];
      #keyFiles = [ gpgSshKeyFile ];
    };

    # home.file.".ssh/config".text = ''
    #   Host HydrogenLocal
    #     Hostname 192.168.0.26

    #   Host OxygenLocal
    #     Hostname 192.168.0.158

    #   Match host Nitrogen exec is_local_conn
    #     HostName 192.168.0.55
    #     Port 22175

    #   Match host Nitrogen
    #     Hostname 1.tcp.eu.ngrok.io
    #     Port 26096

    #   Host *
    #     User ${config.user.name}
    #     IdentityFile ~/.ssh/id_rsa.pub
    # '';

    # systemd.services.ngrok = {
    #   wantedBy = [ "multi-user.target" ];
    #   after = [ "network.target" ];
    #   description = "ngrok ssh tunnel";
    #   serviceConfig = { ExecStart = "${pkgs.ngrok}/bin/ngrok tcp 22"; };
    # };
  };
}
