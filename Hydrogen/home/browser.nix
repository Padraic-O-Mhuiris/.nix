{ config, lib, pkgs, ... }:

let
  bitwarden = { id = "nngceckbapebfimnlniiiahkandclblb"; };
  metamask = { id = "nkbihfbeogaeaoehlefnkodbefgpgknn"; };
  ublock = { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; };
in {
  programs.google-chrome = {
    enable = true;
  };
}

