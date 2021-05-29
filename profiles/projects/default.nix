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

  secrets = {
    url = "git@github.com:Padraic-O-Mhuiris/.secrets.git";
    path = "/home/padraic/.secrets";
  };

  fetch-projects = pkgs.writeShellScriptBin "fetch-projects" ''
    #!/usr/bin/env bash

    [[ ! -f ${financeProject.path}  ]] && ${pkgs.git}/bin/git clone ${financeProject.url} ${financeProject.path}

    [[ ! -f ${orgProject.path} ]] && ${pkgs.git}/bin/git clone ${orgProject.url} ${orgProject.path}
    [[ ! -f ${orgProject.path}/inbox.org ]] && /run/current-system/sw/bin/rm -rf ${orgProject.path} && ${pkgs.git}/bin/git clone ${orgProject.url} ${orgProject.path}

    [[ ! -f ${secrets.path}  ]] && ${pkgs.git}/bin/git clone ${secrets.url} ${secrets.path}
  '';
in {
  home-manager.users.padraic = {
    systemd.user.services = {
      fetch-projects = {
        Unit = {
          Description = "Project Fetch Service";
          After = [ "ssh-agent.service" "gpg-agent.service" ];
        };
        Service = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = 5;
          ExecStart = "${fetch-projects}/bin/fetch-projects";
        };
        Install = { WantedBy = [ "default.target" ]; };
      };
    };
  };
}
