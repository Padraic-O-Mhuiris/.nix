{ config, lib, pkgs, ... }:
let pubkeys = (import ./keys.nix);
in {
  home.file.".ssh/hydrogen.pub".text = pubkeys.hydrogen;
  home.file.".ssh/config".text = ''
    Host myserver
        Hostname 8.8.8.8
        User admin
        IdentityFile ~/.ssh/hydrogen.pub
  '';
}
