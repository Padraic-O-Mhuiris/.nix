{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.ssh;
  configDir = config.dotfiles.configDir;

  sshPublicKeyFile = "${config.dotfiles.keysDir}/id_rsa.pub";
in {
  options.modules.shell.ssh = {
    enable = mkBoolOpt false;
    enableRemoteAccess = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ ngrok ];

    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
      knownHosts = {
        "Hydrogen" = {
          hostNames = [ "Hydrogen" "192.168.0.26" ];
          publicKeyFile = sshPublicKeyFile;
        };
        "Oxygen" = {
          hostNames = [ "Oxygen" "192.168.0.158" ];
          publicKeyFile = sshPublicKeyFile;
        };
        "Nitrogen" = {
          hostNames = [ "Nitrogen" "192.168.0.55" "1.tcp.eu.ngrok.io" ];
          publicKeyFile = sshPublicKeyFile;
        };
      };
    };

    users.users."${config.user.name}".openssh.authorizedKeys.keyFiles =
      [ sshPublicKeyFile ];
  };
}
