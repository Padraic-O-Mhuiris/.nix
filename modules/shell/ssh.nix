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
  options.modules.shell.ssh = with types; {
    enable = mkBoolOpt false;
    sshConfigFile = mkPathOpt null;
  };

  config = mkIf cfg.enable (mkMerge [
    {
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
    }

    (mkIf (cfg.sshConfigFile != null) {

      systemd.services."ssh_config_overwrite" = {
        description = "Overwrite local ssh config";
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "oneshot";
          User = "${config.user.name}";
          Group = "${config.user.group}";
          RemainAfterExit = "yes";
          StandardOutput = "journal";
          ExecStart = ''
            [ -f ${cfg.sshConfigFile} ] && ${pkgs.coreutils}/bin/install -o ${config.user.name} -g ${config.user.group} -m 0400 ${cfg.sshConfigFile} /home/${config.user.name}/ssh/config
          '';
        };
      };
    })
  ]);
}
