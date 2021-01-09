{ config, lib, pkgs, ... }:

let

  financeProject = {
    url = "git@github.com:Padraic-O-Mhuiris/.finance.git";
    path = "/home/padraic/.finance";
  };

  orgProject = {
    url = "git@github.com:Padraic-O-Mhuiris/.org.git";
    path = "/home/padraic/.org";
  };

  fetch-projects = pkgs.writeShellScriptBin "fetch-projects" ''
    [[ ! -f ${financeProject.path}  ]] && ${pkgs.git}/bin/git clone ${financeProject.url} ${financeProject.path}

    if [[ ! -f ${orgProject.path} ]]
    then
      ${pkgs.git}/bin/git clone ${orgProject.url} ${orgProject.path}
    elif [[ ! -f ${orgProject.path}/inbox.org ]]
    then
      rm -rf ${orgProject.path}
      ${pkgs.git}/bin/git clone ${orgProject.url} ${orgProject.path}
    fi'';
in {

  home-manager.users.padraic = {
    systemd.user.services = {
      fetch-projects = {
        Unit = {
          Description = "Project Fetch Service";
          After =
            [ "ssh-agent.service" "network-online.target" "gpg-agent.service" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${fetch-projects}/bin/fetch-projects";
          RestartSec = 20;
          Restart = "always";
        };
        Install = { WantedBy = [ "default.target" "network-online.target" ]; };
      };
    };
  };
}
