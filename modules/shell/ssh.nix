{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.ssh;
  configDir = config.dotfiles.configDir;

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

    user.packages = with pkgs; [ is_local_conn ];

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

    user.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFlro/QUDlDpaA1AQxdWIqBg9HSFJf9Cb7CPdsh0JN7 padraic-o-mhuiris@protonmail.com"
    ];

    modules.services.ngrok = {
      enable = cfg.enableRemoteAccess;
      configFile = age.secrets.ngrokConfig.path;
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
