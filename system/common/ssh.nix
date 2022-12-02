{ config, lib, pkgs, ... }:

{

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  programs.ssh.startAgent = true;
}
