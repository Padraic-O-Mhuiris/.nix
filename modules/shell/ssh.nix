{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.ssh;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.ssh = {
    enable = mkBoolOpt false;
    enableRemoteAccess = mkBookOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ ngrok ];

    services.openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    users.users."${config.user.name}".openssh.authorizedKeys.keyFiles =
      [ "${config.dotfiles.keysDir}/id_rsa.pub" ];

    # home.file.".ssh/id_rsa.pub".source =
    #   "${config.dotfiles.keysDir}/id_rsa.pub";

    home.file.".ssh/config".text = ''
      Host Hydrogen
           Hostname 8.8.8.8
           User ${config.user.name}
           IdentityFile ~/.ssh/id_rsa.pub

      Host Nitrogen_local
           Hostname 192.168.0.55
           User ${config.user.name}
           Port 22175

      Host Nitrogen_remote
           Hostname 1.tcp.eu.ngrok.io
           User ${config.user.name}
           Port 26096
    '';

  };
}
