{ config, lib, pkgs, ... }:

{
  environment.interactiveShellInit = ''
    alias ls='exa'
    alias cat='bat'
  '';
}
