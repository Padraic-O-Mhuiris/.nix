{ config, lib, pkgs, ... }:
let
  org = builtins.fetchGit {
    url = "ssh://git@github.com/Padraic-O-Mhuiris/.org.git";
  };
in {

  # add files to home directory if not already present
  home.file.".org".source = org;
}
