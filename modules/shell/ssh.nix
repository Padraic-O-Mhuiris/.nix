{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.ssh;
  configDir = config.dotfiles.configDir;

  sshPublicKeyFile = "${config.dotfiles.keysDir}/id_rsa.pub";

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

    users.users."${config.user.name}".openssh.authorizedKeys.keyFiles =
      [ sshPublicKeyFile ];

    home.file.".ssh/config".text = ''
      Host HydrogenLocal
        Hostname 192.168.0.26

      Host OxygenLocal
        Hostname 192.168.0.158

      Match host Nitrogen exec is_local_conn
        HostName 192.168.0.55
        Port 26096

      Match host Nitrogen
        Hostname 1.tcp.eu.ngrok.io
        Port 26096

      Host *
        User ${config.user.name}
        IdentityFile ~/.ssh/id_rsa.pub
    '';

  };
}
