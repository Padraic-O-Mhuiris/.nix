{ config, lib, pkgs, ... }:

{
  home-manager.users.padraic = {
    systemd.user.services = {
      projects = {
        Unit = {
          Description = "Clones project repositories from external sources";
          After = [ "network-online.target" ];
        };
        Service = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart =
            "${pkgs.git}/bin/git clone git@github.com:Padraic-O-Mhuiris/.finance.git $HOME/.finance";
        };
        Install = { WantedBy = [ "default.target" ]; };
      };
    };

  };

}
